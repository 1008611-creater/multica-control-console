# 工作区主要项目审批清单

扫描范围：`E:\codex`

规则：同一产品的主工作区、分支、release、preview 和 worktree 合并为一个项目组；缓存、归档、生成物和临时目录不计入主要项目。

## 主要项目组

### 1. 念念 AI 本地站点 / niannian-ai-web

- 主路径：`E:\codex\niannianai\niannianai`
- 同组包含多个 niannian-ai-web 分支、release 和 worktree，以及 `E:\codex\aisp\niannian-ai-billing-worktree`
- 当前是工作区中最复杂的主产品组

### 2. AI 带货与 AI 图片视频生产系统

- 主路径：`E:\codex\aisp\aidaihuo`
- 同组系统：`ai-action-transfer-commerce-video-system`、`ai-daihuo-video-system`、`ai-image-video-production-system`
- `aidaihuo` 是当前最大的单一项目目录

### 3. AI 生产知识库 / aixtgz

- 路径：`E:\codex\aisp\aixtgz`
- Git 项目，包含 AI 生产系统、研究资料和外部仓库

### 4. Aidaihuo Chat Handoff Control

- 路径：`E:\codex\aisp\aidaihuo-handoff-control`
- 独立 Git 源码镜像，面向交接和协作控制

### 5. AI Video Service

- 路径：`E:\codex\ai-video-service-github`
- 独立 Git 项目，Node 服务

### 6. Jellyfish AI Short Drama Studio

- 路径：`E:\codex\Jellyfish_deploy`
- 包含源码、上传部署副本和 MCP 部分

### 7. Website Native System

- 路径：`E:\codex\wangzhan`
- 独立网站项目

### 8. OpenChatCut AI 视频编辑器

- 源码路径：`E:\codex\niannianai\niannianzhijian`
- 同组包含 release 副本，以及已打包应用 `E:\codex\local-apps\OpenChatCut-0.2.3`

### 9. DeepTutor 智能学习助手

- 主路径：`E:\codex\niannianai\niannianxuexi`
- 同组包含 learning-mode、preview 和多个 PR worktree

### 10. MiniMax H3 / ComfyUI Spectrum

- 主路径：`E:\codex\niannianai\h3-spectrum-20260809`
- 同组包含 H3 upstream、cache 和 route audit 相关目录

### 11. Blender MCP

- 路径：`E:\codex\niannianai\blender-mcp`
- 独立 Python 项目，为 Blender 提供 MCP 集成

### 12. dh.cauai.fun 本地前端副本

- 路径：`E:\codex\niannianai\nianniannzhixuan`
- 独立 Node 前端副本

### 13. OpenStarterKit / 带货站点副本

- 主路径：`E:\codex\niannianai\nianniandaihuo`
- 相关播放/部署目录：`E:\codex\niannian-stage-playback`

### 14. 论文到期刊论文翻修生产系统

- 路径：`E:\codex\aisp\thesis-to-journal-paper-revision-system`
- 独立的论文翻修生产系统

## 未计入主要项目

- `E:\codex\archive`：归档区
- `E:\codex\model_cache`：模型缓存
- `E:\codex\_audit`：审计材料
- `E:\codex\ppt_*`、`_pptx_extract`：PPT 生成物和提取物
- `E:\codex\niannian-worker-first-frame-chunks-20260814`：视频中间产物
- `E:\codex\tools`、`E:\codex\_img2`：工具和资产辅助目录
- `E:\codex\heikesong`：Godot 项目，未识别为 AI 项目
- `E:\codex\paper-design`：设计项目，未识别为 AI 主项目

## 审批格式

请回复要保留的编号，例如：

`保留：1、2、5、6、8、9`

未列入保留清单的项目组，将在下一步移动到 `E:\codex\archive\quarantine-20260911` 下的独立归档目录；不会直接删除。

