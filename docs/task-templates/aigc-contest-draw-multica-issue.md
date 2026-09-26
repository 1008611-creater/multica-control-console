# Multica 任务包：AIGC 比赛抽卡批次跟踪与串行出图

下面内容可直接粘贴到 Multica Issue。它把一批抽卡从「聊天里的临时动作」变成「有状态、有回执、可复核的 Multica 任务」：先把已回收的图片登记成真实证据，再把未提交的编号停在人工授权门之后，由同一条任务承载批次状态、授权、失败处理和用户的 4 选 1。

## 元数据

- 风险等级：L3
- 责任角色：内容生产
- 把关角色：用户
- 项目身份：`aigc-contest-draw-v1`（不可变，禁止用任务标题判定项目）
- 关联控制台：`projects/AIGC比赛抽卡/`
- 输出模式：创建任务并留下回执

## 目标

把 contest-batch-01 的抽卡状态收敛到一条可追踪的 Multica 任务上：C01 至 C06 用真实文件路径和序列号登记，C07 至 C15 停在用户当次授权门之后按一次一张串行推进，批次状态、失败处理和 4 选 1 全部落在可复核的文件里，而不是散落在聊天记录。

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
3. 待用户拍板项：4 选 1 结果、C07 至 C15 的付费授权；
4. 保存到 `projects/AIGC比赛抽卡/receipts/` 的回执草稿。

## 硬约束

- 不登录任何平台，不代发，不自动发布；
- 付费出图必须用户当次明确授权；2026-09-26 的授权只覆盖已提交的 C01 至 C06，不覆盖 C07 至 C15；
- 同一时刻只允许一个桥作业，必须一次一张串行提交，禁止并发，避免浏览器锁超时；
- 作业返回 `queued` 且 `retryAllowed: false` 时，只用免费补下载模式 `POST /v1/maintenance` 的 `dl-serial` 取回同一序列号，禁止重新提交；
- 不读取或保存 Cookie、Token、密钥；
- 未知字段写「缺」，不估算积分余额或比赛成绩。

## 验收

- [ ] Issue 有明确的项目身份 `aigc-contest-draw-v1`；
- [ ] 15 行状态表与 `projects/AIGC比赛抽卡/receipts/contest-batch-01.md` 一致；
- [ ] 每个已回收编号都有真实存在的文件路径和序列号；
- [ ] 未授权的编号保持「未提交」，不用默认值掩盖；
- [ ] 没有新增登录、发布或付费调用；
- [ ] `npm run verify` 通过；
- [ ] 用户确认后，才允许把回执标记为 accepted。

## 失败处理

- 桥离线、代理离线或登录失效：停止并输出原因，不出图、不重复扣费；
- 浏览器锁超时：说明并发冲突，改为一次一张串行；
- 单张返回 `queued`：改用免费 `dl-serial` 补下载，仍失败则转人工看站内，禁止重跑；
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
- C07 至 C15 尚未提交。

本任务要做的事：
1. 输出一张 15 行的批次状态表：编号 / 作业号 / 状态 / 序列号 / 图片路径；
2. 已回收编号必须给出真实存在的文件路径；未提交编号写「未提交」，未知字段写「缺」；
3. 列出待用户拍板项：C01 至 C06 的 4 选 1、C07 至 C15 的付费授权；
4. 把结果写成回执草稿，追加到本批回执文件。

严格禁止：
- 不登录任何平台，不代发，不自动发布；
- 未经用户当次明确授权，不得调用 POST /v1/jobs 出图；2026-09-26 的授权只覆盖已提交的 C01 至 C06；
- 同一时刻只允许一个桥作业，必须一次一张串行提交，禁止并发；
- 作业返回 queued 且 retryAllowed:false 时，只用 POST /v1/maintenance 的 dl-serial 模式免费补下载，禁止重新提交；
- 不读取或保存 Cookie、Token、密钥；
- 不编造缺失数据，未知字段写「缺」。

完成前运行 npm run verify。
```
