# AI 项目目录审计

审计日期：2026-09-11

## 审计范围

- `E:\codex`
- `C:\Users\lsb\Documents` 中明显与 AI / Codex / Trae / API / 提示词相关的目录
- `C:\Users\lsb\Downloads` 中明显与 AI 视频工作流相关的目录

本次只读取目录结构、Git 元数据、项目标记文件和文件计数/体积摘要；没有移动、删除或改写项目文件。

## 核心发现

### 1. `E:\codex\niannianai` 是最大的混合工作区

- 一级子目录：约 173 个。
- 轻量扫描体积：约 29.6 GB；该数值排除了常见依赖、缓存和构建目录，实际占用会更大。
- 目录中同时混有主工作区、Git worktree、release、candidate、stage、preview、audit、tmp 和输出目录。
- 发现 77 个一级目录带有 `.git`：
  - 10 个仍有有效的 worktree 元数据。
  - 54 个 `.git` 文件指向已经不存在的 worktree 元数据，属于“断链 worktree 快照”候选。
  - 13 个是普通 Git 仓库目录。
- 主工作区 `E:\codex\niannianai\niannianai` 当前分支为 `codex/h3-video-node-completion-final`，存在约 388 个已修改/删除文件，不能直接当作干净副本处理。
- 有效 worktree 也普遍存在大量未提交变更，不能直接删除或合并。

### 2. `E:\codex\aisp` 是第二个大型混合区

- 轻量扫描体积：约 62.4 GB，排除了 `node_modules`、虚拟环境、构建、缓存等目录。
- 其中：
  - `aidaihuo`：约 53.3 GB，包含大量 QA、release、preview、tmp、output、archive 和候选快照。
  - `aixtgz`：约 7.4 GB，像是独立的 AI 生产系统 / 资料仓库。
  - `ai-image-video-production-system`：约 115 MB，规模较小但结构相对清晰。
  - `niannian-ai-billing-worktree`：约 7.8 MB，独立 Git worktree。
- `aidaihuo\.git` 目前是空目录，不是可正常识别的 Git 工作区；但其中可能仍有有价值的快照或产物，不能按普通仓库直接处理。

### 3. 已经存在一些可独立归类的目录

- `E:\codex\_audit`：约 306 MB，主要是 PPT / AI 工具审计材料。
- `E:\codex\archive`：约 939 MB，已经是归档区，可作为后续统一归档位置。
- `E:\codex\model_cache`：模型缓存，不应和项目仓库混放。
- `E:\codex\local-apps`：本地应用，不应和源码项目混放。
- `E:\codex\ppt_*`、`_pptx_extract`、`niannian-stage-playback`、`niannian-worker-first-frame-chunks-*`：明显属于生成结果、提取物或临时工作产物。
- `E:\codex\wangzhan`、`E:\codex\ai-video-service-github`、`E:\codex\paper-design`、`E:\codex\Jellyfish_deploy`：相对独立的项目仓库，应保持独立，不建议和 `niannianai` 合并。

### 4. 用户目录中还有少量 AI 相关散落物

- `C:\Users\lsb\Documents\农大API项目中枢`：结构清晰的知识 / 项目中枢。
- `C:\Users\lsb\Documents\刺猬星球提示词资料库`：结构清晰的提示词资料库。
- `C:\Users\lsb\Documents\最新seedance2.0白嫖`：一个说明文本加一个约 293 MB 的大文件，性质更像下载资料，不像源码项目。
- `C:\Users\lsb\Downloads` 下有 3 组 MiniMax H3 工作流文件，其中 `minimax_h3_image_only_9x16_api` 看起来是整理/验证版，其余两组可能是早期下载副本。
- `C:\Users\lsb\Documents\Codex` 是按日期保存的对话/任务资料，不应和源码仓库混放。
- `C:\Users\lsb\Documents\trae_projects\111` 是独立的网页项目，不应并入 AI 源码总目录。

## 初步整理建议

建议采用“保留活动路径、归档断链副本、单独收纳产物”的方案：

1. 保留当前正在使用的主工作区和有效 Git worktree 原路径不动。
2. 把 54 个断链 worktree 快照先移动到一个带日期的隔离归档目录，不删除；移动前生成清单，并保留原目录名。
3. 在 `E:\codex` 下把生成物、下载物、模型缓存和源码项目分成四类，但不强行改名正在运行的项目。
4. 把 `aidaihuo` 内部的 `tmp`、`qa`、`output`、`release`、`preview`、`archive` 做第二层清理；这一步需要逐类核对，不能整目录搬走。
5. 对 Downloads 中重复的 MiniMax 工作流只保留一份“验证版 + 原始版”，但先比较文件内容后再处理。

## 当前阻塞点

“断链 worktree”不等于“无价值目录”：其中可能有未提交文件、生成物或人工修改。下一步需要选择：

- 保守：只建立索引和归档候选清单，不移动任何目录。
- 实用：把确认断链且未发现独立 Git 元数据的目录移入可恢复的日期归档区。

