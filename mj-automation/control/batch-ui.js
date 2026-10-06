const $ = (id) => document.getElementById(id);
const esc = (value) => String(value ?? '缺').replace(/[&<>"']/g, (c) => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]));
const state = { bridge: null, batch: null, selectedId: null, refreshBusy: false, loginStatus: {} };
const statusNames = {
  validated:'已检查，待授权', running:'运行中', paused:'已暂停', completed:'已完成', cancelled:'已取消', pending:'待提交',
  running_item:'\u5e73\u53f0\u5904\u7406\u4e2d', completed_item:'\u5df2\u5b8c\u6210', failed:'\u5931\u8d25\u5f85\u6838\u67e5', result_pending:'\u7ed3\u679c\u5f85\u6838\u67e5', skipped:'\u5df2\u8df3\u8fc7', login_required:'\u7b49\u5f85\u6b64\u5de5\u4f5c\u4f4d\u767b\u5f55'
};
const statusClass = (status) => ['completed','completed_item'].includes(status) ? 'good' : ['validated','running','running_item','pending','paused','result_pending','login_required'].includes(status) ? 'warn' : ['failed','cancelled'].includes(status) ? 'bad' : '';
const chip = (status) => `<span class="status-chip ${statusClass(status)}">${esc(statusNames[status] || status || '缺')}</span>`;
function setText(id, text) { const node = $(id); if (node) node.textContent = text; }
async function api(url, options = {}) {
  if (!options.method || String(options.method).toUpperCase() === 'GET') {
    options = { ...options, cache: 'no-store', headers: { ...(options.headers || {}), 'Cache-Control': 'no-cache' } };
  }
  const response = await fetch(url, options);
  const text = await response.text();
  let body = {}; try { body = text ? JSON.parse(text) : {}; } catch { body = { raw: text }; }
  if (!response.ok) { const detail = body.detail || body.message || body.raw || `HTTP ${response.status}`; const error = new Error(typeof detail === 'string' ? detail : JSON.stringify(detail)); error.body = body; throw error; }
  return body;
}
function jsonOptions(body) { return { method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify(body) }; }
function setAction(message, bad = false) { setText('actionMsg', message); if ($('actionMsg')) $('actionMsg').style.color = bad ? 'var(--bad)' : 'var(--muted)'; }
function setValidation(message, bad = false) { setText('validationMsg', message); if ($('validationMsg')) $('validationMsg').style.color = bad ? 'var(--bad)' : 'var(--good)'; }
function parseInput(raw) {
  const text = String(raw || '').trim(); if (!text) throw new Error('请先粘贴任务清单。');
  try { const value = JSON.parse(text); return Array.isArray(value) ? value : value.items; } catch {
    return text.split(/\r?\n/).filter(Boolean).map((line, index) => { try { return JSON.parse(line); } catch { throw new Error(`第 ${index + 1} 行不是有效 JSON。`); } });
  }
}
function inputPayload() {
  const items = parseInput($('taskInput').value); if (!Array.isArray(items) || !items.length) throw new Error('任务清单必须是非空数组。');
  const payload = { batch_id: $('batchName').value.trim() || `batch-${new Date().toISOString().slice(0,10)}`, name: $('batchName').value.trim() || '未命名批次', concurrency: Number($('maxActive').value || 3), items };
  if ($('outputDir').value.trim()) payload.output_dir = $('outputDir').value.trim();
  return payload;
}
async function importBatch() {
  try {
    const payload = inputPayload();
    const check = await api('/control/batches/validate', jsonOptions(payload));
    const errors = check.errors || [];
    if (errors.length) { setValidation(`检查未通过：${errors.slice(0, 5).map((x) => `${x.item ? `${x.item}：` : ''}${x.message}`).join('；')}`, true); $('validatedPreview').classList.add('hidden'); return; }
    const saved = await api('/control/batches', jsonOptions(payload));
    state.batch = saved; state.selectedId = saved.items?.[0]?.id || null;
    setValidation(`已保存批次：${saved.items.length} 项任务，并发上限 ${saved.concurrency}。尚未提交。`);
    $('validatedPreview').classList.remove('hidden');
    $('validatedPreview').innerHTML = `<b>后端已持久化</b><div class="small" style="margin-top:6px">批次 ${esc(saved.batchId)} · 输出目录 ${esc(saved.outputDir)}${(check.warnings || []).length ? ` · 警告 ${check.warnings.length} 条` : ''}</div>`;
    renderBatch(); renderMonitor(); updateGate();
  } catch (error) { setValidation(error.message, true); $('validatedPreview').classList.add('hidden'); }
}
function clearEditor() { $('batchName').value = ''; $('taskInput').value = ''; $('outputDir').value = ''; setValidation('已清空输入，没有提交任何任务。', false); $('validatedPreview').classList.add('hidden'); }
function renderHistory(items) {
  const select = $('batchHistory'); const selected = state.batch?.batchId || '';
  select.innerHTML = `<option value="">批次历史</option>${(items || []).map((item) => `<option value="${esc(item.batchId)}">${esc(item.name || item.batchId)} · ${esc(statusNames[item.status] || item.status)}</option>`).join('')}`;
  select.value = selected;
}
function itemStatus(item) { return item.status === 'running' ? 'running_item' : item.status === 'completed' ? 'completed_item' : item.status; }
function resultSummary(item) { if (item.status === 'completed') return `${(item.outputFiles || []).length} 个成品`; if (item.failureReason) return item.failureReason; const r = item.lastResult || {}; return r.message || r.resultStatus || '等待后端回读'; }
function itemAction(item) {
  const id = esc(item.id);
  if (item.status === 'login_required') { const login = state.loginStatus[item.id]; const text = login ? (login.loggedIn ? '\u5df2\u68c0\u6d4b\u5230\u767b\u5f55' : login.running ? '\u7a97\u53e3\u5df2\u5f00\uff0c\u5c1a\u672a\u767b\u5f55' : '\u767b\u5f55\u7a97\u53e3\u672a\u8fd0\u884c') : '\u5c1a\u672a\u68c0\u67e5'; return `<button class="ghost" data-login="${id}" type="button">\u6253\u5f00\u6b64\u69fd\u4f4d\u767b\u5f55</button> <button class="ghost" data-login-check="${id}" type="button">\u68c0\u67e5\u767b\u5f55\u72b6\u6001</button> <button class="ghost" data-skip="${id}" type="button">\u8df3\u8fc7</button><div class="small">\u69fd\u4f4d ${esc(item.slot)} | ${esc(text)}</div>`; }
  if (['failed','result_pending'].includes(item.status)) return `<button class="ghost" data-skip="${id}" type="button">跳过</button> <button class="ghost" data-resubmit="${id}" type="button">人工重提</button>`;
  if (item.status === 'completed' && (item.outputFiles || []).length) return `<button class="ghost" data-open="${id}" type="button">打开成品</button>`;
  return '<span class="small">—</span>';
}
function formatDuration(seconds) {
  const value = Math.max(0, Math.floor(Number(seconds) || 0));
  if (value < 60) return `${value}\u79d2`;
  const minutes = Math.floor(value / 60); const secs = value % 60;
  if (minutes < 60) return `${minutes}\u5206${String(secs).padStart(2, '0')}\u79d2`;
  const hours = Math.floor(minutes / 60); return `${hours}\u5c0f\u65f6${String(minutes % 60).padStart(2, '0')}\u5206`;
}
function timestamp(value) {
  if (typeof value === 'number' && Number.isFinite(value)) return value > 1e12 ? value / 1000 : value;
  const parsed = Date.parse(String(value || '')); return Number.isFinite(parsed) ? parsed / 1000 : 0;
}
function jobForItem(item) {
  const id = item?.currentJobId;
  return id ? (state.bridge?.jobs?.items || []).find((job) => job.jobId === id) || null : null;
}
function phaseFromJob(job, item) {
  const itemStatus = item?.status;
  if (itemStatus === 'completed' || job?.ok === true) return { key:'completed', label:'\u5df2\u5b8c\u6210', tone:'good' };
  if (itemStatus === 'result_pending') return { key:'review', label:'\u5f85\u4eba\u5de5\u6838\u67e5', tone:'warn' };
  if (itemStatus === 'failed') return { key:'failed', label:'\u5931\u8d25\uff0c\u5df2\u6682\u505c', tone:'bad' };
  if (itemStatus === 'login_required') return { key:'login', label:'\u7b49\u5f85\u767b\u5f55', tone:'warn' };
  if (itemStatus === 'skipped') return { key:'skipped', label:'\u5df2\u8df3\u8fc7', tone:'' };
  const text = `${job?.logTail || ''} ${job?.message || ''} ${job?.resultStatus || ''}`.toLowerCase();
  if (text.includes('\u7b49\u5f85\u6d4f\u89c8\u5668\u9501') || text.includes('\u6d4f\u89c8\u5668\u9501') || text.includes('lock') || text.includes('\u7b49\u5f85\u9501')) return { key:'lock', label:'\u7b49\u5f85\u6d4f\u89c8\u5668\u5de5\u4f5c\u4f4d', tone:'warn' };
  if (text.includes('\u7b49\u5f85\u751f\u6210') || text.includes('\u6392\u961f') || text.includes('queued') || text.includes('serial')) return { key:'queue', label:'\u5e73\u53f0\u6392\u961f / \u51fa\u56fe\u4e2d', tone:'warn' };
  if (text.includes('blob') || text.includes('\u4e0b\u8f7d') || text.includes('download')) return { key:'capture', label:'\u6293\u53d6\u6210\u54c1', tone:'' };
  if (text.includes('\u6821\u9a8c') || text.includes('verify') || text.includes('sha')) return { key:'verify', label:'\u6821\u9a8c\u6210\u54c1\u6587\u4ef6', tone:'' };
  if (text.includes('\u7acb\u5373\u751f\u6210') || text.includes('\u63d0\u793a\u8bcd\u5df2\u8f93\u5165') || text.includes('\u5df2\u70b9\u51fb')) return { key:'submit', label:'\u63d0\u4ea4\u5e73\u53f0\u4efb\u52a1', tone:'' };
  if (job?.status === 'running' || itemStatus === 'running') return { key:'processing', label:'\u5e73\u53f0\u5904\u7406\u4e2d', tone:'' };
  if (job?.status === 'done' && job?.resultStatus === 'exception') return { key:'failed', label:'\u6267\u884c\u5931\u8d25\uff0c\u5df2\u6682\u505c', tone:'bad' };
  return { key:'starting', label:'\u51c6\u5907\u5de5\u4f5c\u4f4d', tone:'' };
}
function phaseForBatch(batch) {
  if (!batch) return { key:'idle', label:'\u7b49\u5f85\u6279\u6b21', tone:'' };
  if (batch.status === 'paused') return { key:'paused', label:'\u5df2\u6682\u505c \u00b7 \u7b49\u5f85\u4eba\u5de5\u5904\u7406', tone:'warn' };
  if (batch.status === 'completed') return { key:'completed', label:'\u6279\u6b21\u5df2\u5b8c\u6210', tone:'good' };
  if (batch.status === 'cancelled') return { key:'cancelled', label:'\u6279\u6b21\u5df2\u53d6\u6d88', tone:'bad' };
  if (batch.status === 'validated') return { key:'validated', label:'\u5df2\u68c0\u67e5\uff0c\u7b49\u5f85\u5f00\u59cb', tone:'warn' };
  const active = (batch.items || []).filter((item) => item.status === 'running');
  const phases = active.map((item) => phaseFromJob(jobForItem(item), item));
  if (!active.length) return { key:'waiting', label:'\u7b49\u5f85\u5de5\u4f5c\u4f4d', tone:'warn' };
  const unique = [...new Set(phases.map((phase) => phase.label))];
  return { key:'running', label:unique.length === 1 ? unique[0] : `\u8fd0\u884c\u4e2d \u00b7 ${active.length} \u4e2a\u5de5\u4f5c\u4f4d`, tone:'' };
}
function estimateRemaining(batch) {
  const items = batch?.items || []; const active = items.filter((item) => item.status === 'running'); const pending = items.filter((item) => item.status === 'pending');
  const durations = items.map((item) => { const start = timestamp(item.startedAt); const end = timestamp(item.finishedAt); return item.status === 'completed' && start && end && end >= start ? end - start : 0; }).filter((value) => value > 0);
  if (!active.length && !pending.length) return { text:'\u5df2\u6ca1\u6709\u5269\u4f59\u4efb\u52a1', tone:'good' };
  if (!durations.length) return { text:`\u9884\u8ba1\u5269\u4f59\uFF1A\u7b49\u5f85\u9996\u9879\u5b8c\u6210\u540e\u5f00\u59cb\u4f30\u7b97\uFF0C\u5269\u4f59 ${active.length + pending.length} \u9879\u3002`, tone:'warn' };
  const average = durations.reduce((sum, value) => sum + value, 0) / durations.length; const slots = Math.max(1, Number(batch.concurrency) || 1); const eta = Math.ceil((active.length + pending.length) * average / slots);
  const prefix = batch.status === 'paused' ? '\u5df2\u6682\u505c\uFF0C\u6062\u590d\u540e' : '\u9884\u8ba1';
  return { text:`${prefix}\u5269\u4f59\u7ea6 ${formatDuration(eta)}\uFF08\u6309 ${durations.length} \u9879\u5df2\u5b8c\u6210\u5e73\u5747 ${formatDuration(average)} \u4f30\u7b97\uFF09`, tone: batch.status === 'paused' ? 'warn' : '' };
}
function anomalyAlerts(batch) {
  const alerts = []; const items = batch?.items || []; const active = items.filter((item) => item.status === 'running'); const pending = items.filter((item) => item.status === 'pending');
  if (batch?.status === 'paused' && batch.pauseReason) alerts.push({ tone:'warn', text:`\u6279\u6b21\u5df2\u6682\u505c\uFF1A${batch.pauseReason}` });
  if (batch?.status === 'running' && state.bridge?.browser && !state.bridge.browser.loggedIn) alerts.push({ tone:'bad', text:'\u5de5\u4f5c\u4f4d\u68c0\u6d4b\u5230\u672a\u767b\u5f55\uFF0C\u5df2\u505c\u6b62\u8865\u4f4d' });
  if (batch?.status === 'running' && state.bridge?.watchdog?.paused) alerts.push({ tone:'warn', text:'\u81ea\u52a8\u770b\u62a4\u5df2\u6682\u505c\uFF0C\u4e0d\u4f1a\u81ea\u52a8\u6062\u590d\u5b50\u8fdb\u7a0b' });
  if (batch?.status === 'running' && pending.length && !active.length) alerts.push({ tone:'bad', text:'\u6709\u5f85\u63d0\u4ea4\u4efb\u52a1\uFF0C\u4f46\u6ca1\u6709\u6d3b\u52a8\u5de5\u4f5c\u4f4d' });
  active.forEach((item) => { const job = jobForItem(item); const start = timestamp(job?.startedAt) || timestamp(item.startedAt); const elapsed = start ? Date.now() / 1000 - start : 0; const phase = phaseFromJob(job, item); if (job?.status === 'done' && job?.ok !== true) alerts.push({ tone:'warn', text:`${item.id}\u5df2\u7ed3\u675f\uff0c\u4f46\u5c1a\u672a\u786e\u8ba4\u6210\u54c1\u56de\u6267` }); if (phase.key === 'queue' && elapsed > 600) alerts.push({ tone:'warn', text:`${item.id}\u5728\u5e73\u53f0\u6392\u961f\u5df2\u8d85\u8fc7 10 \u5206\u949f` }); if (elapsed > 1800) alerts.push({ tone:'bad', text:`${item.id}\u5df2\u8fd0\u884c ${formatDuration(elapsed)}\uFF0C\u8bf7\u91cd\u70b9\u68c0\u67e5` }); });
  return alerts.slice(0, 4);
}
function eventLabel(event) {
  const labels = { batch_created:'\u6279\u6b21\u5df2\u521b\u5efa', batch_started:'\u6279\u6b21\u5f00\u59cb\u8fd0\u884c', item_started:'\u4efb\u52a1\u8fdb\u5165\u5de5\u4f5c\u4f4d', item_completed:'\u4efb\u52a1\u5b8c\u6210\u5e76\u5199\u5165\u6210\u54c1', item_failed:'\u4efb\u52a1\u5931\u8d25', item_result_pending:'\u7ed3\u679c\u5f85\u4eba\u5de5\u6838\u67e5', batch_paused:'\u6279\u6b21\u5df2\u6682\u505c', batch_resumed:'\u6279\u6b21\u7ee7\u7eed\u8fd0\u884c', item_skipped:'\u4efb\u52a1\u5df2\u8df3\u8fc7', item_login_required:'\u7b49\u5f85\u5de5\u4f4d\u767b\u5f55' };
  return labels[event] || String(event || '\u72b6\u6001\u66f4\u65b0');
}
function renderMonitor() {
  const batch = state.batch; const bar = $('monitorProgressBar');
  if (!batch) {
    setText('monitorPhase', '\u7b49\u5f85\u6279\u6b21'); setText('monitorPhaseChip', '\u672a\u8fd0\u884c'); setText('monitorProgressText', '0 / 0 \u5df2\u5b8c\u6210'); setText('monitorUpdated', '\u7b49\u5f85\u72b6\u6001\u56de\u8bfb'); setText('monitorEstimate', '\u7b49\u5f85\u6279\u6b21');
    if (bar) bar.style.width = '0%'; if ($('monitorSlowest')) $('monitorSlowest').textContent = '\u5f53\u524d\u6ca1\u6709\u8fd0\u884c\u4e2d\u7684\u4efb\u52a1\u3002';
    if ($('monitorAlerts')) $('monitorAlerts').innerHTML = '<div class="empty">\u6ca1\u6709\u5f02\u5e38</div>'; if ($('monitorSlots')) $('monitorSlots').innerHTML = '<div class="slot-card"><div class="empty">\u6682\u65e0\u5de5\u4f5c\u4f4d\u8fd0\u884c</div></div>';
    if ($('monitorTimeline')) $('monitorTimeline').innerHTML = '<div class="empty">\u6279\u6b21\u4e8b\u4ef6\u4f1a\u663e\u793a\u5728\u8fd9\u91cc\u3002</div>'; return;
  }
  const items = batch.items || []; const done = items.filter((item) => item.status === 'completed').length; const total = items.length;
  const phase = phaseForBatch(batch); setText('monitorPhase', phase.label); setText('monitorPhaseChip', phase.label); const chipNode = $('monitorPhaseChip'); if (chipNode) chipNode.className = `phase-chip ${phase.tone || ''}`;
  setText('monitorProgressText', `${done} / ${total} \u5df2\u5b8c\u6210 \u00b7 ${items.filter((item) => item.status === 'pending').length} \u5f85\u63d0\u4ea4 \u00b7 ${items.filter((item) => ['failed','result_pending','login_required'].includes(item.status)).length} \u5f85\u5904\u7406`);
  setText('monitorEstimate', estimateRemaining(batch).text); if (bar) bar.style.width = `${total ? Math.round(done / total * 100) : 0}%`; setText('monitorUpdated', batch.updatedAt ? `\u6700\u540e\u66f4\u65b0 ${new Date(batch.updatedAt).toLocaleTimeString('zh-CN')}` : '\u7b49\u5f85\u72b6\u6001\u56de\u8bfb');
  const alerts = anomalyAlerts(batch); if ($('monitorAlerts')) $('monitorAlerts').innerHTML = alerts.length ? alerts.map((alert) => `<div class="alert-row ${alert.tone}"><span class="alert-dot"></span><span>${esc(alert.text)}</span></div>`).join('') : '<div class="empty">\u6ca1\u6709\u5f02\u5e38</div>';
  const active = items.filter((item) => item.status === 'running'); const slotMap = new Map(active.map((item) => [Number(item.slot), item]));
  (state.bridge?.batchScheduler?.active || []).filter((row) => row.batchId === batch.batchId).forEach((row) => { if (!slotMap.has(Number(row.slot))) { const item = items.find((candidate) => candidate.id === row.itemId); if (item) slotMap.set(Number(row.slot), item); } });
  const slots = Array.from({length: Math.min(3, Number(batch.concurrency) || 3)}, (_, index) => index + 1).map((slot) => {
    const item = slotMap.get(slot); const job = item ? jobForItem(item) : null; const phaseInfo = item ? phaseFromJob(job, item) : null;
    if (!item) return `<div class="slot-card"><div class="slot-title"><b>\u5de5\u4f5c\u4f4d ${slot}</b><span class="phase-chip">\u7a7a\u95f2</span></div><div class="slot-meta">\u6210\u529f\u5b8c\u6210\u540e\u4f1a\u81ea\u52a8\u9886\u53d6\u4e0b\u4e00\u9879</div></div>`;
    const started = Number(job?.startedAt) || timestamp(item.startedAt); const elapsed = started ? formatDuration(Date.now() / 1000 - started) : '\u8ba1\u65f6\u4e2d';
    return `<div class="slot-card active ${phaseInfo?.tone === 'warn' ? 'review' : ''}"><div class="slot-title"><b>\u5de5\u4f5c\u4f4d ${slot}</b><span class="phase-chip ${phaseInfo?.tone || ''}">${esc(phaseInfo?.label || '\u8fd0\u884c\u4e2d')}</span></div><div class="slot-task" title="${esc(item.name || item.id)}">${esc(item.name || item.id)}</div><div class="slot-meta">\u5df2\u8fd0\u884c ${esc(elapsed)}<br>${job?.recordId ? `\u56de\u6267 ${esc(job.recordId)}` : '\u7b49\u5f85\u56de\u6267'}</div></div>`;
  });
  if ($('monitorSlots')) $('monitorSlots').innerHTML = slots.join('');
  const slow = active.map((item) => { const job = jobForItem(item); const started = Number(job?.startedAt) || timestamp(item.startedAt); return { item, seconds: started ? Date.now() / 1000 - started : 0, phase: phaseFromJob(job, item) }; }).sort((a, b) => b.seconds - a.seconds)[0];
  if ($('monitorSlowest')) $('monitorSlowest').innerHTML = slow ? `\u5f53\u524d\u8017\u65f6\u6700\u957f\uFF1A<b>${esc(slow.item.name || slow.item.id)}</b>?${esc(formatDuration(slow.seconds))}?\u9636\u6bb5\u4e3a?${esc(slow.phase.label)}??` : (batch.pauseReason ? `\u6682\u505c\u539f\u56e0\uFF1A${esc(batch.pauseReason)}` : '\u5f53\u524d\u6ca1\u6709\u8fd0\u884c\u4e2d\u7684\u4efb\u52a1\u3002');
  const events = (batch.events || []).slice(-8).reverse(); if ($('monitorTimeline')) $('monitorTimeline').innerHTML = events.length ? events.map((event) => `<div class="timeline-row"><span class="timeline-time">${event.at ? new Date(event.at).toLocaleTimeString('zh-CN') : '\u7f3a\u65f6\u95f4'}</span><span class="timeline-text"><b>${esc(eventLabel(event.event))}</b>${event.itemId ? ` \u00b7 ${esc(event.itemId)}` : ''}</span></div>`).join('') : '<div class="empty">\u6279\u6b21\u4e8b\u4ef6\u4f1a\u663e\u793a\u5728\u8fd9\u91cc\u3002</div>';
}
function renderBatch() {
  const batch = state.batch;
  if (!batch) { setText('batchBadge','没有批次'); setText('batchIdValue','缺'); ['totalValue','doneValue','runningValue','queuedValue','blockedValue'].forEach((id) => setText(id,'0')); $('queueTable').innerHTML = '<div class="empty">导入批次后，这里显示后端持久化的任务状态。</div>'; renderSelected(); updateGate(); return; }
  const items = batch.items || []; const done = items.filter((x) => x.status === 'completed').length; const running = items.filter((x) => x.status === 'running').length; const queued = items.filter((x) => x.status === 'pending').length; const blocked = items.filter((x) => ['failed','result_pending','login_required'].includes(x.status)).length;
  setText('batchBadge', statusNames[batch.status] || batch.status); setText('batchIdValue', batch.batchId); setText('totalValue', items.length); setText('doneValue', done); setText('runningValue', running); setText('queuedValue', queued); setText('blockedValue', blocked);
  if (batch.pauseReason) setAction(`暂停原因：${batch.pauseReason}`, true);
  $('queueTable').innerHTML = `<table class="table"><thead><tr><th>编号</th><th>状态</th><th>槽位</th><th>尝试</th><th>作业号</th><th>回执/原因</th><th>操作</th></tr></thead><tbody>${items.map((item) => `<tr><td><button class="ghost mono" data-task="${esc(item.id)}" type="button">${esc(item.id)}</button></td><td>${chip(itemStatus(item))}</td><td>${item.slot ? `槽位 ${item.slot}` : '缺'}</td><td>${esc(item.attempts)}</td><td class="mono">${esc(item.currentJobId || '缺')}</td><td>${esc(resultSummary(item))}</td><td>${itemAction(item)}</td></tr>`).join('')}</tbody></table>`;
  renderSelected(); updateGate();
}
function renderSelected() {
  const panel = $('selectedTask'); const item = state.batch?.items?.find((x) => x.id === state.selectedId);
  if (!item) { panel.innerHTML = '<div class="empty">点击任务编号查看提示词、作业号、回执和成品位置。</div>'; return; }
  const result = item.lastResult || {};
  panel.innerHTML = `<div class="toolbar"><div><div class="label">任务详情</div><h3>${esc(item.id)} · ${esc(item.name)}</h3></div>${chip(itemStatus(item))}</div><div class="detail-grid"><div class="detail-item"><b>提示词</b><span>${esc(item.prompt)}</span></div><div class="detail-item"><b>画幅 / 版本</b><span>${esc(item.aspect)} / ${esc(item.version)}</span></div><div class="detail-item"><b>作业号 / 工作位</b><span class="mono">${esc(item.currentJobId || '缺')} / ${esc(item.slot || '缺')}</span></div><div class="detail-item"><b>保存位置</b><span>${esc((item.outputFiles || []).join('；') || item.outputDir || state.batch.outputDir || '缺')}</span></div></div><div class="small" style="margin-top:12px">${esc(item.failureReason || `回执：${result.resultStatus || result.status || '缺'}；开始：${item.startedAt || '缺'}；结束：${item.finishedAt || '缺'}`)}</div><details style="margin-top:10px"><summary class="small">查看安全回执摘要</summary><pre>${esc(JSON.stringify(result, null, 2))}</pre></details>`;
}
function updateGate() {
  const batch = state.batch; const online = Boolean(state.bridge?.health?.ok); const confirmed = $('paidConfirm').checked; const canStart = Boolean(batch && ['validated','paused'].includes(batch.status) && online && confirmed && !(batch.items || []).some((x) => ['failed','result_pending','login_required'].includes(x.status))); 
  $('startBatchBtn').disabled = !canStart; $('resumeBatchBtn').disabled = !(batch && batch.status === 'paused' && confirmed); $('pauseBatchBtn').disabled = !(batch && batch.status === 'running'); $('cancelBatchBtn').disabled = !(batch && ['running','paused'].includes(batch.status)); $('gateChip').textContent = canStart ? '可以开始真实提交' : '\u9700\u68c0\u67e5\u6279\u6b21\u3001\u5904\u7406\u963b\u585e\u5e76\u786e\u8ba4\u8d39\u7528'; $('gateChip').className = `status-chip ${canStart ? 'good' : 'warn'}`;
}
async function refresh() {
  if (state.refreshBusy) return; state.refreshBusy = true;
  try {
    const data = await api('/control/state'); state.bridge = data; const online = Boolean(data.health?.ok); const logged = Boolean(data.browser?.loggedIn);
    $('healthDot').className = `dot ${online ? 'good' : 'bad'}`; setText('healthText', online ? (logged ? '桥已连接，浏览器已登录' : '桥已连接，等待浏览器登录') : '本地桥不可用'); setText('bridgeValue', online ? '已连接' : '不可用'); setText('bridgeMeta', data.health?.bridge || '批次服务已加载'); setText('browserValue', logged ? '已登录' : data.browser?.running ? '未登录' : '未启动'); setText('browserMeta', data.browser?.url || '登录由你本人完成'); const active = data.batchScheduler?.active?.length || 0; setText('concurrencyValue', `${active} / 3`); setText('concurrencyMeta', `${data.batchScheduler?.manualReview?.length || 0} 项待人工核查`);
    const batches = data.batches || [];
    renderHistory(batches);
    if (state.batch?.batchId) state.batch = await api(`/control/batches/${encodeURIComponent(state.batch.batchId)}`); else if (batches.length) { const focusLatest = new URLSearchParams(window.location.search).get('focus') === 'latest'; const candidate = focusLatest ? (batches.find((item) => ['paused','validated','running'].includes(item.status)) || batches[0]) : batches[0]; state.batch = await api(`/control/batches/${encodeURIComponent(candidate.batchId)}`); }
    if (state.batch && !state.selectedId) state.selectedId = state.batch.items?.[0]?.id || null; renderBatch(); renderMonitor(); renderJobs(data.jobs?.items || []); renderReceipts(data.receipts?.items || []); updateGate();
  } catch (error) { $('healthDot').className = 'dot bad'; setText('healthText','无法连接本地桥'); setText('bridgeValue','不可用'); setText('bridgeMeta', error.message); updateGate(); } finally { state.refreshBusy = false; }
}
function renderJobs(items) { if (!items.length) { $('jobsTable').innerHTML = '<div class="empty">????????????</div>'; return; } $('jobsTable').innerHTML = `<table class="table"><thead><tr><th>???</th><th>??</th><th>??</th><th>??</th><th>??</th><th>??</th><th>??</th></tr></thead><tbody>${items.slice(0, 30).map((job) => { const phase = phaseFromJob(job, null); const elapsed = job.startedAt ? (job.status === 'running' ? formatDuration(Date.now() / 1000 - job.startedAt) : '???') : '?'; return `<tr><td class="mono">${esc(job.jobId)}</td><td><span class="phase-chip ${phase.tone || ''}">${esc(phase.label)}</span></td><td>${chip(job.status)}</td><td>${chip(job.resultStatus || 'unknown')}</td><td>${elapsed}</td><td>${esc(job.aspect)}</td><td>${job.startedAt ? new Date(job.startedAt * 1000).toLocaleString('zh-CN') : '?'}</td></tr>`; }).join('')}</tbody></table>`; }
function renderReceipts(items) { if (!items.length) { $('receiptsTable').innerHTML = '<div class="empty">本机还没有回执台账。</div>'; return; } $('receiptsTable').innerHTML = `<div class="table-wrap"><table class="table"><thead><tr><th>任务号</th><th>状态</th><th>画幅</th><th>文件数</th><th>时间</th></tr></thead><tbody>${items.slice(-15).reverse().map((row) => `<tr><td class="mono">${esc(row.task_id || row.taskId || '缺')}</td><td>${esc(row.status || '缺')}</td><td>${esc(row.aspect_applied || row.aspect_requested || row.aspect || '缺')}</td><td>${Array.isArray(row.files) ? row.files.length : '缺'}</td><td>${esc(row.ts || row.started_at || '缺')}</td></tr>`).join('')}</tbody></table></div>`; }
async function runAction(message, fn) { setAction(message); try { await fn(); setAction('操作已完成'); await refresh(); } catch (error) { setAction(error.message, true); } }
async function openBrowser() { await runAction('正在打开可见浏览器', () => api('/control/browser/start', {method:'POST'})); }
async function stopBrowser() { await runAction('正在关闭可见浏览器', () => api('/control/browser/stop', {method:'POST'})); }
async function startBatch() { await runAction('正在启动批次', () => api(`/control/batches/${encodeURIComponent(state.batch.batchId)}/start`, jsonOptions({paid_confirmed:true}))); }
async function pauseBatch() { await runAction('正在暂停补位', () => api(`/control/batches/${encodeURIComponent(state.batch.batchId)}/pause`, jsonOptions({reason:'用户已暂停补位'}))); }
async function resumeBatch() { await runAction('正在继续批次', () => api(`/control/batches/${encodeURIComponent(state.batch.batchId)}/resume`, jsonOptions({paid_confirmed:true}))); }
async function openSlotLogin(id) { await runAction('\u6b63\u5728\u6253\u5f00\u6307\u5b9a\u5de5\u4f5c\u4f4d\u6d4f\u89c8\u5668', () => api(`/control/batches/${encodeURIComponent(state.batch.batchId)}/items/${encodeURIComponent(id)}/login`, {method:'POST'})); }
async function checkSlotLogin(id) { try { const result = await api(`/control/batches/${encodeURIComponent(state.batch.batchId)}/items/${encodeURIComponent(id)}/login`); state.loginStatus[id] = result; setAction(result.loggedIn ? `\u5de5\u4f5c\u4f4d ${result.slot} \u5df2\u767b\u5f55\uff1b\u70b9\u201c\u7ee7\u7eed\u6279\u6b21\u201d\u540e\u4f1a\u518d\u6b21\u6838\u9a8c` : `\u5de5\u4f5c\u4f4d ${result.slot} \u5c1a\u672a\u68c0\u6d4b\u5230\u767b\u5f55\uff0c\u8bf7\u5728\u8be5\u7a97\u53e3\u767b\u5f55\u540e\u518d\u68c0\u67e5`, !result.loggedIn); renderBatch(); renderMonitor(); } catch (error) { setAction(error.message, true); } }
async function cancelBatch() { if (!window.confirm('确认取消后续补位？已提交的平台作业不会被强制终止。')) return; await runAction('正在取消后续补位', () => api(`/control/batches/${encodeURIComponent(state.batch.batchId)}/cancel`, {method:'POST'})); }
async function skipItem(id) { await runAction('正在跳过任务', () => api(`/control/batches/${encodeURIComponent(state.batch.batchId)}/items/${encodeURIComponent(id)}/skip`, {method:'POST'})); }
async function resubmitItem(id) { if (!window.confirm(`确认人工重新提交 ${id}？这可能产生重复扣费。`)) return; await runAction('正在准备人工重提', () => api(`/control/batches/${encodeURIComponent(state.batch.batchId)}/items/${encodeURIComponent(id)}/resubmit`, jsonOptions({paid_confirmed:true, confirm_repeat_charge:true}))); }
async function openOutput(id) { await runAction('正在打开成品位置', () => api(`/control/batches/${encodeURIComponent(state.batch.batchId)}/items/${encodeURIComponent(id)}/open-output`, {method:'POST'})); }
async function focusLatestBatch() { const batches = state.bridge?.batches || []; const candidate = batches.find((item) => ["paused","validated","running"].includes(item.status)) || batches[0]; if (!candidate) { setAction("当前没有可继续的已保存批次。", true); return; } state.batch = await api(`/control/batches/${encodeURIComponent(candidate.batchId)}`); state.selectedId = state.batch.items?.[0]?.id || null; renderBatch(); renderMonitor(); document.getElementById("queueCard")?.scrollIntoView({behavior:"smooth", block:"start"}); setAction(`已选中最近批次：${candidate.name || candidate.batchId}。请确认费用后点击“继续批次”。`); }
async function runLint() { await runAction('正在执行免费自检', () => api('/v1/maintenance', jsonOptions({mode:'lint'}))); }
async function toggleWatch(mode) { await runAction(mode === 'pause' ? '正在暂停自动看护' : '正在恢复自动看护', () => api(`/control/watchdog/${mode}`, {method:'POST'})); }
$('validateBtn').addEventListener('click', importBatch); $('focusLatestBtn').addEventListener('click', focusLatestBatch); $('clearBtn').addEventListener('click', clearEditor); $('paidConfirm').addEventListener('change', updateGate); $('startBatchBtn').addEventListener('click', startBatch); $('pauseBatchBtn').addEventListener('click', pauseBatch); $('resumeBatchBtn').addEventListener('click', resumeBatch); $('cancelBatchBtn').addEventListener('click', cancelBatch); $('openBrowserBtn').addEventListener('click', openBrowser); $('stopBrowserBtn').addEventListener('click', stopBrowser); $('refreshBtn').addEventListener('click', refresh); $('lintBtn').addEventListener('click', runLint); $('pauseWatchBtn').addEventListener('click', () => toggleWatch('pause')); $('resumeWatchBtn').addEventListener('click', () => toggleWatch('resume')); $('batchHistory').addEventListener('change', async (event) => { if (event.target.value) { state.batch = await api(`/control/batches/${encodeURIComponent(event.target.value)}`); state.selectedId = state.batch.items?.[0]?.id || null; renderBatch(); renderMonitor(); } }); $('queueTable').addEventListener('click', (event) => { const target = event.target; const task = target.closest('[data-task]'); if (task) { state.selectedId = task.dataset.task; renderSelected(); } const skip = target.closest('[data-skip]'); if (skip) skipItem(skip.dataset.skip); const resubmit = target.closest('[data-resubmit]'); if (resubmit) resubmitItem(resubmit.dataset.resubmit); const open = target.closest('[data-open]'); if (open) openOutput(open.dataset.open); const login = target.closest('[data-login]'); if (login) openSlotLogin(login.dataset.login); const loginCheck = target.closest('[data-login-check]'); if (loginCheck) checkSlotLogin(loginCheck.dataset.loginCheck); });
refresh(); window.setInterval(refresh, 3000);
window.addEventListener('focus', () => refresh());
window.addEventListener('pageshow', () => refresh());
document.addEventListener('visibilitychange', () => { if (document.visibilityState === 'visible') refresh(); });
