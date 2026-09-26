---
name: mxai-contest-draw
description: "AIGC 比赛抽卡。用户要给比赛、作品集或样片批量出国内版 Midjourney 候选图时使用：整理提示词、走本机 mxai 桥做免费自检，用户当次授权后串行提交，再按作业号回收高清图和回执。不登录、不发布、不自动重跑付费任务。"
---

# AIGC 比赛抽卡

把比赛需要的画面编译成可提交的国内版 Midjourney 提示词，并通过本机桥串行出候选图。一次只处理一个已授权批次。

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
4. 授权后逐张提交 `POST /v1/jobs`。同一提示词返回 `deduped: true` 时直接复用，不强制重出。
5. 用 `GET /v1/jobs/{作业号}` 回收结果。`running` 继续等；`done` 登记图片；`stale` 或下载失败改为人工看站内，禁止自动重交。
6. 把作业号、序列号、文件路径和用户的 4 选 1 结果写入比赛控制台。

## 硬约束

- 不代登录，不读取或保存 Cookie、Token、密钥。
- 不自动发布，不把候选图写成已入选。
- 单批最多 15 张；超过时拆批并重新请求授权。
- 桥不在线、代理不在线、登录失效、提示词有风险词时，不出图。
- 尺寸、版本、风格以用户本批要求为准；没写时用 `9:16`、`v8.2`。

## 完成标准

每张图都有真实作业号和文件路径，或明确标记为「缺」并给出原因。没有这些证据，不得报告出图完成。
