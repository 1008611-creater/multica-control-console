import assert from 'node:assert/strict';
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import test, { after } from 'node:test';
import { runBatch } from './production_machine.mjs';

const bridgeUrl = 'http://mock-bridge.invalid';
const tempDirs = [];

function fixture() {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'mj-retry-gate-'));
  tempDirs.push(dir);
  const manifestPath = path.join(dir, 'manifest.json');
  fs.writeFileSync(manifestPath, JSON.stringify({
    project_id: 'retry-gate-test',
    batch_id: 'retry-gate-test',
    version: 'test',
    items: [{ batch: 'case', item_id: 'ITEM-1', generation_prompt: 'fixture prompt', aspect_ratio: '16:9' }],
  }), 'utf8');
  return {
    dir,
    argv: ['--manifest', manifestPath, '--batch', 'case', '--max-retries', '2', '--poll-ms', '1', '--receipts', path.join(dir, 'attempts.jsonl'), '--summary', path.join(dir, 'summary.json')],
  };
}

function mockRequest({ responses = {}, submitError = null } = {}) {
  const posts = [];
  const reads = [];
  return {
    posts,
    reads,
    request: async (url, options = {}) => {
      assert.ok(url.startsWith(bridgeUrl), `unexpected URL: ${url}`);
      if (options.method === 'POST') {
        const payload = JSON.parse(options.body);
        posts.push(payload);
        if (submitError) throw submitError;
        return { jobId: `job-${posts.length}`, status: 'running', deduped: false };
      }
      const jobId = decodeURIComponent(url.split('/').at(-1));
      reads.push(jobId);
      const response = responses[jobId];
      return typeof response === 'function' ? response() : response;
    },
  };
}

function readReceipt(dir) {
  return fs.readFileSync(path.join(dir, 'attempts.jsonl'), 'utf8')
    .split(/\r?\n/).filter(Boolean).map((line) => JSON.parse(line));
}

const nonRetryCases = [
  ['business queued status', { status: 'done', ok: false, result: { status: 'queued', retryAllowed: false, billed: true } }],
  ['receipt_pending status', { status: 'done', ok: false, result: { status: 'receipt_pending', retry_allowed: false } }],
  ['download_failed status', { status: 'done', ok: false, result: { status: 'download_failed', retryAllowed: false, billed: true } }],
  ['need_login status even with contradictory flags', { status: 'done', ok: false, result: { status: 'need_login', retryAllowed: true, billed: false, chargeKnown: true } }],
  ['unknown deduction despite retryAllowed', { status: 'done', ok: false, result: { status: 'failed', retryAllowed: true, submitted: true } }],
  ['positive deduction despite retryAllowed', { status: 'done', ok: false, result: { status: 'aspect_not_applied', retryAllowed: true, billed: true, chargeKnown: true } }],
  ['page-reported failure with retry denied', { status: 'done', ok: false, result: { status: 'page_reported_failed', retryAllowed: false } }],
  ['top-level resultStatus and retryAllowed aliases', { status: 'done', ok: false, resultStatus: 'queued', retry_allowed: false, billed: true }],
];

for (const [name, response] of nonRetryCases) {
  test(`does not resubmit ${name}`, async () => {
    const f = fixture();
    const mock = mockRequest({ responses: { 'job-1': response } });
    const summary = await runBatch({ argv: f.argv, bridgeUrl, request: mock.request, wait: async () => {}, log: () => {} });
    assert.equal(mock.posts.length, 1);
    assert.equal(summary.results.length, 1);
    const terminal = readReceipt(f.dir).find((row) => row.event === 'terminal');
    assert.equal(terminal.attempt, 1);
    assert.equal(terminal.retry_allowed, response.result?.retryAllowed ?? response.result?.retry_allowed ?? response.retryAllowed ?? response.retry_allowed ?? false);
  });
}

test('retries only an explicitly permitted, confirmed no-charge failure', async () => {
  const f = fixture();
  const mock = mockRequest({ responses: {
    'job-1': { status: 'done', ok: false, result: { status: 'aspect_not_applied', retryAllowed: true, submitted: false, billed: false, chargeKnown: true } },
    'job-2': { status: 'done', ok: true, result: { status: 'ok', ok: true, billed: true } },
  } });
  const summary = await runBatch({ argv: f.argv, bridgeUrl, request: mock.request, wait: async () => {}, log: () => {} });
  assert.equal(mock.posts.length, 2);
  assert.equal(mock.posts[0].force, false);
  assert.equal(mock.posts[1].force, true);
  const terminals = readReceipt(f.dir).filter((row) => row.event === 'terminal');
  assert.equal(terminals.length, 2);
  assert.equal(terminals[1].attempt, 2);
  assert.equal(terminals[1].retry_of, 'job-1');
  assert.equal(summary.success_count, 1);
});

test('recognizes the /v1/jobs explicit zero-deduction fields', async () => {
  const f = fixture();
  const mock = mockRequest({ responses: {
    'job-1': { status: 'done', ok: false, resultStatus: 'aspect_not_applied', retryAllowed: true, chargeKnown: true, actualPointDeduction: 0 },
    'job-2': { status: 'done', ok: true, resultStatus: 'ok' },
  } });
  await runBatch({ argv: f.argv, bridgeUrl, request: mock.request, wait: async () => {}, log: () => {} });
  assert.equal(mock.posts.length, 2);
  const first = readReceipt(f.dir).find((row) => row.event === 'terminal');
  assert.equal(first.billed, false);
  assert.equal(first.charge_known, true);
  assert.equal(first.actual_point_deduction, 0);
});

test('does not resubmit after an ambiguous POST failure', async () => {
  const f = fixture();
  const error = new Error('HTTP 504');
  error.status = 504;
  error.body = { detail: { status: 'dispatch_timeout' } };
  const mock = mockRequest({ submitError: error });
  const summary = await runBatch({ argv: f.argv, bridgeUrl, request: mock.request, wait: async () => {}, log: () => {} });
  assert.equal(mock.posts.length, 1);
  assert.equal(mock.reads.length, 0);
  assert.equal(summary.results[0].status, 'dispatch_timeout');
  assert.equal(summary.results[0].retry_allowed, false);
});

test('keeps polling an outer queued job and then records its nested business status', async () => {
  const f = fixture();
  let reads = 0;
  const mock = mockRequest({ responses: {
    'job-1': () => {
      reads += 1;
      return reads === 1
        ? { status: 'queued', ok: false }
        : { status: 'done', ok: false, result: { status: 'receipt_pending', retryAllowed: false } };
    },
  } });
  const summary = await runBatch({ argv: f.argv, bridgeUrl, request: mock.request, wait: async () => {}, log: () => {} });
  assert.equal(mock.posts.length, 1);
  assert.equal(reads, 2);
  assert.equal(summary.results[0].status, 'receipt_pending');
  assert.equal(summary.results[0].job_status, 'done');
});

after(() => {
  const tempRoot = path.resolve(os.tmpdir()) + path.sep;
  for (const dir of tempDirs) {
    const resolved = path.resolve(dir);
    if (!resolved.startsWith(tempRoot)) throw new Error(`refusing to remove test path outside temp root: ${resolved}`);
    fs.rmSync(resolved, { recursive: true, force: true });
  }
});
