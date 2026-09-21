---
name: daily-self-media-operator
description: "Run the daily self-media workflow in this workspace: turn verified user materials into Xiaohongshu image posts or Douyin videos, create drafts and visual previews, prepare AitoEarn publication, and publish only after the user gives explicit final confirmation."
---

# 每日自媒体运营

这是 `E:\codex\niannianai\zimeiti` 的唯一日常运营入口。每次用户给出任务后，先读取工作区 `AGENTS.md`，再按本 Skill 执行。

## 输入与交付

- 输入：用户任务、真实素材、目标平台、账号、发布授权和已知事实。
- 工作目录：每条内容在 `drafts/<主题>-<平台>-<日期>/` 中沉淀素材清单、平台稿、预览、检查和回执。
- 默认交付：内容目标、事实依据、平台稿、可视预览、风险检查和一个用户下一步动作。

## 公共边界

- 只使用用户提供或项目中可核验的素材、事实和结果；不编造价格、参数、销量、效果或平台数据。
- 原图模式：按指定顺序使用已有图片，不生成、重绘、加字、裁切、贴纸或重复素材。
- 不读取、输出、写入或迁移 Cookie、密码、API Key、Token、证书或 `.env` 内容。
- 默认只制作草稿和预览。登录、上传、保存平台草稿和发布都是外部操作。
- 最终发布必须由用户明确确认；平台页面出现“发布中”时只算已受理，只有“发布成功”才算完成。

## 路由

### 小红书图文

1. 建立 `xhs-post.md`，包含标题、正文、标签和图片顺序；标题不超过 20 字。
2. 创建 `preview.html`，先检查首屏、比例、图片清晰度和原图边界。
3. 发布前运行 `scripts/validate_draft.py <draft-directory>`；必须确认标题、图片存在、顺序无重复且 SHA-256 不重复。
4. 使用 Edge 中已登录的 AitoEarn 中国版；确认“浏览器插件 已就绪”和指定小红书账号在线。
5. 新建发布任务，只保留目标账号。按 `xhs-post.md` 顺序上传图片，等待预览图片数与预期一致且不再显示处理中。
6. 填入标题、正文和标签后，向用户复述账号、图片数和标题，索取一次最终确认。
7. 用户确认后发布，等待页面最终“发布成功”，写入 `publish-receipt.md` 并更新 `README.md` 状态。

### 抖音视频

1. 建立 `douyin-post.md`：视频主题、真实素材来源、口播/字幕、标题、描述、话题、封面候选和时长。
2. 视频默认使用用户指定的念念智剪；需要带货选品/成片时使用念念智选网站。不得伪造商品效果、成交或平台数据。
3. 导出可发布视频后，检查文件存在、可播放、画幅为竖版、首帧和音画内容与草稿一致；在 `preview.html` 或同等可视化预览中展示。
4. 使用 Edge 中已登录的 AitoEarn 中国版；确认指定抖音账号在线且插件账号匹配。
5. 上传视频，等到平台预览已完成；填写标题、描述和话题。发布前再次请求用户最终确认。
6. 用户确认后发布，等待平台最终“发布成功”；写入 `publish-receipt.md` 并更新 `README.md` 状态。

## 失败路径

- 账号离线、插件未就绪或账号不匹配：停止提交，说明对应平台需要保持登录并在 AitoEarn 刷新状态。
- Edge 无法读本机媒体：用户需在 `edge://extensions` 的 ChatGPT 扩展详情中启用“允许访问文件 URL”。
- 上传失败或处理中：不提交，保留草稿和可视状态；完成后再继续。
- 付费生成、公开发布、账户/权限变更或凭据操作：先取得该动作的明确授权。

## 每日调用

```text
使用 $daily-self-media-operator 完成今天的自媒体任务：<任务>。
平台：<小红书图文 / 抖音视频>。
素材：<路径或说明>。
先出草稿和预览，不发布。
```
