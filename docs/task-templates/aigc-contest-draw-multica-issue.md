# Multica 任务包：AIGC 比赛抽卡批次跟踪与受控并发出图

This Multica Issue template now uses strict three-concurrent execution: while a batch is non-terminal and has an executable or retryable item, keep three slots; refill terminal slots immediately; use authorized failed-item retries to fill short slots; C07 remains no-retry.

## 元数据

- 风险等级：L3
- 责任角色：内容生产
- 把关角色：用户
- 项目身份：`aigc-contest-draw-v1`（不可变，禁止用任务标题判定项目）
- 关联控制台：`projects/AIGC比赛抽卡/`
- 输出模式：创建任务并留下回执

## 目标

把 contest-batch-01 的抽卡状态收敛到一条可追踪的 Multica 任务上：记录 C01 至 C08 的真实状态、路径和序列号，及 C07、C09 的失败回执，并按用户确认跟踪后续批次进度；批次状态、失败处理和 4 选 1 都留在可复核文件里。

## 输入

- `PROJECT_CONTEXT.md`、`CONSTRAINTS.md`；
- `projects/AIGC比赛抽卡/project_state.yaml`；
- `projects/AIGC比赛抽卡/receipts/contest-batch-01.md`；
- `projects/AIGC比赛抽卡/prompts/contest-batch-01.md`；
- `skills/第四批-AIGC比赛抽卡/mxai-contest-draw/SKILL.md`；
- 本机抽卡桥 `http://127.0.0.1:8765`（模型 `midjourney`，版本 `v8.2`，画幅 `16:9`）；
- 用户当次给出的画面清单和付费授权。

## 输出

1. 一张 15 行批次状态表：编号 / 作业号 / 状态 / 序列号 / 图片路径；
2. 每个已回收编号对应的真实文件路径，未回收或未提交的编号明确标记；
3. 待用户拍板项：C01 至 C06 的 4 选 1；C07、C09 站内最终状态或实际扣积分数值仍缺时均如实记录；
4. 保存到 `projects/AIGC比赛抽卡/receipts/` 的回执草稿。

## 硬约束

- 不登录任何平台，不代发，不自动发布；
- 2026-09-26 用户已明确授权本批 15 张；本批授权覆盖批内失败项在三个并发槽位内的重提；新批次仍需重新授权；
- While the batch is non-terminal and an executable or retryable item exists, keep three bridge jobs; record each job separately; never exceed three; use authorized failed-item retries to fill short slots.
- 作业返回 `queued` 且 `retryAllowed: false` 时，只用免费补下载模式 `POST /v1/maintenance` 的 `dl-serial` 取回同一序列号，禁止重新提交；
- 不读取或保存 Cookie、Token、密钥；
- 未知字段写「缺」，不估算积分余额或比赛成绩。

## 验收

- [ ] Issue 有明确的项目身份 `aigc-contest-draw-v1`；
- [ ] 15 行状态表与 `projects/AIGC比赛抽卡/receipts/contest-batch-01.md` 一致；
- [ ] 每个已回收编号都有真实存在的文件路径和序列号；
- [ ] C07 明确记录为 `page_reported_failed`、序列号和缺失图片，不标为未提交；
- [ ] C09 原始失败回执保留且重提成功；C10、C12 的首轮锁超时回执保留并已重提；C10-r4、C12-r4、C13-r3 当前占满三个槽位；C14、C15 等槽位补位；C07 的历史不重试例外仍被保留；
- [ ] 每次重提记录 `retry_of`、新作业号、新序列号和扣费状态；不静默无限重试，实际扣积分状态缺失时不作推断；
- [ ] 没有未授权的登录、发布或付费调用；所有付费出图都在本批 15 张授权范围内；
- [ ] `npm run verify` 通过；
- [ ] 用户确认后，才允许把回执标记为 accepted。

## 失败处理

- 桥离线、代理离线或登录失效：停止并输出原因，不出图、不重复扣费；
- Browser-lock timeout or single-item failure: preserve the original receipt and refill immediately; use authorized failed-item retries to fill short slots.
- A `queued` result uses free `dl-serial` first; `page_reported_failed`, `stale`, or failed free download preserves the original receipt and uses an authorized retry slot; keep three slots while executable or retryable work exists.
- 缺少当次付费授权：停在提示词和预计积分，不调用 `POST /v1/jobs`；
- 批次状态与回执不一致：只报告差异和影响范围，不擅自改状态。

## 任务正文（可直接粘贴到 Multica Issue）

```text
你正在 Multica 上跟踪一次 AIGC 比赛抽卡批次。

项目身份：aigc-contest-draw-v1
控制台：E:\codex\multica\projects\AIGC比赛抽卡
本批回执：E:\codex\multica\projects\AIGC比赛抽卡\receipts\contest-batch-01.md
本批提示词：E:\codex\multica\projects\AIGC比赛抽卡\prompts\contest-batch-01.md
技能说明：E:\codex\multica\skills\第四批-AIGC比赛抽卡\mxai-contest-draw\SKILL.md
图片目录：E:\codex\multica\mj-automation\output
抽卡桥：http://127.0.0.1:8765（模型 midjourney，版本 v8.2，画幅 16:9）

请先读取：
1. projects/AIGC比赛抽卡/project_state.yaml
2. projects/AIGC比赛抽卡/receipts/contest-batch-01.md
3. projects/AIGC比赛抽卡/prompts/contest-batch-01.md
4. skills/第四批-AIGC比赛抽卡/mxai-contest-draw/SKILL.md

当前真实状态（2026-09-26）：
- C01 至 C06 已回收真实图片，尺寸均为 2912×1632；
- C06 由序列号 serial-2103726832829337600 免费补下载取得；
- 用户已核实 C07 序列号 serial-2103846648898654208 站内失败、无成品；实际扣积分数值缺（用户未提供具体数值）；
- C08 已提交成功：contest-batch-01-C08-r2_1e7c6a212f，序列号 serial-2103856976441118720，图片 E:\codex\multica\mj-automation\output\contest-batch-01-C08-r2_1e7c6a212f_net.webp，尺寸 2912×1632；C09 原作业 contest-batch-01-C09-r2_460dbd57d9 失败后已重提为 contest-batch-01-C09-r3_460dbd57d9，序列号 serial-2103910138304794624，图片已回收；C11 已成功回收，序列号 serial-2103915522050494464；C10-r4、C12-r4、C13-r3 当前运行中；C14、C15 等槽位补位。

本任务要做的事：
1. 输出一张 15 行的批次状态表：编号 / 作业号 / 状态 / 序列号 / 图片路径；
2. 已回收编号必须给出真实存在的文件路径；未提交编号写「未提交」，未知字段写「缺」；
3. 列出待用户拍板项：C01 至 C06 的 4 选 1；C07、C09 站内最终状态或实际扣积分数值仍缺时均如实记录；
4. 把结果写成回执草稿，追加到本批回执文件。

严格禁止：
- 不登录任何平台，不代发，不自动发布；
- The 2026-09-26 authorization covers this batch and failed-item retries; while a batch is non-terminal and an executable or retryable item exists, keep three bridge jobs; a new batch requires fresh authorization;
- C07 remains the explicit no-retry exception; C09-C15 retain their original failure receipts and retry links; all future active work follows strict three-concurrent execution;
- While a batch is non-terminal and an executable or retryable item exists, keep three bridge jobs in `running` or `queued`; shared profile locks do not change the strict three-concurrent rule;
- 作业返回 queued 且 retryAllowed:false 时，只用 POST /v1/maintenance 的 dl-serial 模式免费补下载，禁止重新提交；
- 不读取或保存 Cookie、Token、密钥；
- 不编造缺失数据，未知字段写「缺」。

完成前运行 npm run verify。
```

## 使用方式

1. 将上面的“任务正文”粘贴到 Multica Issue，或直接将本模板作为 Issue 描述文件。
2. The user-verified C07 failure remains no-retry; C09-C15 have recovered results; future work refills every terminal slot and uses authorized failed-item retries to keep three concurrent jobs.
3. C07 的实际扣积分数值仍缺；登记缺失值，不估算。
4. 按“验收”逐项核对；全部满足且用户确认后，才把回执状态改为 `accepted`。

对应命令（工作目录为仓库根目录）：

```powershell
multica issue create --title "AIGC 抽卡 contest-batch-01 批次跟踪" --description-file docs/task-templates/aigc-contest-draw-multica-issue.md --project 5efb4fa5-81c0-4d91-bc85-17ced9f3acba --assignee-id d96f1b9f-a0b5-47ff-b51f-1f4b45c4dbe5 --status backlog --output json
```
