---
name: mxai-contest-draw
description: "AIGC 比赛抽卡。用户要给比赛、作品集或样片批量出国内版 Midjourney 候选图时使用：整理提示词、走本机 mxai 桥做免费自检，用户当次授权后始终维持三并发作业槽位提交，再按作业号回收高清图和回执。不登录、不发布、不静默重跑付费任务；本批授权内允许在三个并发槽位内重提交失败项。"
---

# AIGC 比赛抽卡

把比赛需要的画面编译成可提交的国内版 Midjourney 提示词，并通过本机桥保持三个作业槽位出候选图；待处理项不足三张时按剩余数量运行。一次只处理一个已授权批次。

## 边界

- 项目身份：`aigc-contest-draw-v1`。
- 桥地址：`http://127.0.0.1:8765`，模型 `midjourney`，默认 `v8.2`。
- 图片目录：`E:\codex\multica\mj-automation\output`。
- 回执目录：`E:\codex\multica\mj-automation\receipts`。
- 比赛控制台：`E:\codex\multica\projects\AIGC比赛抽卡`。
- 作品集只读引用：`E:\codex\aigc-motion-portfolio`。

## 执行顺序

1. 先读项目状态、本技能和用户当次给的画面清单。
2. 调用 `POST /v1/maintenance`，依次做 `env`、`lint`、`lint-prompt`。任一失败就停止。
3. 没有用户当次明确授权时，只交付提示词和预计积分，不调用 `/v1/jobs`。
4. After authorization, submit `POST /v1/jobs`; while the batch is non-terminal and an executable or retryable item exists, keep three bridge jobs in `running` or `queued`, refill terminal slots immediately, never exceed three, and use authorized failed-item retries for short slots.
5. Poll with `GET /v1/jobs/{jobId}`. Keep waiting on `running`; register images on `done`; free-download `queued` or download failures by serial first; preserve receipts for `page_reported_failed`, `stale`, or failed free download, then resubmit within authorization and refill the three slots.
6. 把作业号、序列号、文件路径和用户的 4 选 1 结果写入比赛控制台。

## 硬约束

- 不代登录，不读取或保存 Cookie、Token、密钥。
- 不自动发布，不把候选图写成已入选。
- 单批最多 15 张；超过时拆批并重新请求授权。
- 桥不在线、代理不在线、登录失效、提示词有风险词时，不出图。
- A single failure does not block the batch; every retry records `retry_of`, a new job, serial, and deduction state; while the batch is non-terminal and an executable or retryable item exists, keep three bridge slots, using authorized failed-item retries for short slots, never exceeding three.
- 尺寸、版本、风格以用户本批要求为准；没写时用 `9:16`、`v8.2`。

## 完成标准

每张图都有真实作业号和文件路径，或明确标记为「缺」并给出原因。没有这些证据，不得报告出图完成。
