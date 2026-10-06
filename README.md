# Multica 本地抽卡工作台工程仓库

工作目录：`E:\codex\multica`。本仓库维护 Windows 本地抽卡工作台的中文界面、桥接源码、安装与分发脚本、项目规则和可核验回执。

## 项目分工

- **本仓库**：保存可审查源码、规则、项目状态、任务模板、验收脚本和回执索引。
- **本地控制台软件**：在 Windows 本机运行，目标是让用户看清任务队列、最多三并发、真实回执、成品位置、失败原因和重提条件。产品目标见 [`docs/product-spec.md`](docs/product-spec.md)；首版体验细节见 [`docs/multica-workbench-product-vision.md`](docs/multica-workbench-product-vision.md)。文档中的目标不代表功能已经实现。
- **外部执行现场**：Multica 桌面端、浏览器和图像平台。登录、付费提交、最终选图及发布由用户本人决定；仓库不伪造平台状态。

新任务先读 `PROJECT_CONTEXT.md`、`CONSTRAINTS.md`、`docs/product-spec.md` 和 `docs/acceptance.md`。完成代码或脚本修改后运行 `npm run verify` 与相关测试，并执行 `post-coding-review`。

`runtime/` 是本机依赖与浏览器档案目录，`dist/` 是可重建的正式分发输出；两者不属于源码。重建同版本分发包会覆盖该版本的输出，操作前必须备份并验证恢复。任务回执和本机输出按数据保留规则处理，不得作为构建缓存清理。安装与首次使用见 [`README_FIRST_RUN.md`](README_FIRST_RUN.md)。

---

## 目录结构与支持资料

表中的规范、产品、验收与状态入口用于当前工程；旧创收阶段卡、漫剧控制台和参考资料仍保留作历史或专项素材，不是本地抽卡软件的安装、运行或状态真源。使用前需按对应项目状态重新核对。

| 位置 | 内容 |
|---|---|
| `README.md` | 本文件，项目章程与使用说明 |
| `PROJECT_CONTEXT.md` | 当前技术栈、事实、缺口和非目标 |
| `AGENTS.md` | 项目级工作流、依赖方向和变更纪律 |
| `CONSTRAINTS.md` | 长期质量、安全、权限和风险分级 |
| `docs/` | 产品规格、架构、实施计划、验收清单和 ADR |
| `scripts/verify.ps1` | 统一质量门禁；通过 `npm run verify` 执行 |
| `projects/README.md` | 项目控制台与状态真源索引 |
| `00_审计报告.md` | 旧工作区审计资料；历史快照，使用前重新核对 |
| `01_资产索引.md` | 历史资产路径索引；外部路径状态可能变化 |
| `02_创收路径.md` | 旧创收方向讨论，非当前产品目标 |
| `03_上手清单.md` | 旧阶段行动清单；不替代本仓库当前验收和安全规则 |
| `04_阶段0_唤醒Multica.md` | 阶段 0 当日操作卡：代理 → 运行时可用 → 并发 1 改 3 |
| `05_阶段1_技能与智能体.md` | 阶段 1 操作卡：技能导入 + 4 个智能体 + 1 个小队 |
| `06_阶段2_Autopilot.md` | 阶段 2 操作卡：4 条自动排期 |
| `07_阶段4_三成片发布清单.md` | 阶段 4 操作卡：三条成片统一发布 + 数据闭环 |
| `skills/` | **技能副本区**：五批共 18 个技能，供导入 Multica |
| `projects/天宫漫剧/` | **漫剧社主线项目控制台**：索引 + 状态 + 可直接导入的提示词包（不搬动原始生产目录） |
| `reference/multica/` | Multica 产品能力面、本机环境快照、内置技能包清单 |
| `reference/自媒体资产/` | 从自媒体工作区整理进来的文本类核心资产 + 全局技能库索引 |
| `reference/已有审计/` | 本次审计参考的既有报告 |

## 新任务从哪里开始

不要直接从某一张阶段操作卡开始。先读：

1. `PROJECT_CONTEXT.md`：确认当前事实和不做什么；
2. `CONSTRAINTS.md`：确认安全、真实性和授权边界；
3. `docs/product-spec.md`：确认目标、范围和验收标准；
4. `docs/implementation-plan.md`：确认当前垂直切片与验证方式。

完成修改后运行：

```powershell
npm run verify
```

生命周期固定为：`DEFINE → PLAN → BUILD → VERIFY → REVIEW → SHIP → RETRO`。现有 `03_上手清单.md` 及阶段操作卡仍是执行手册，但不再替代产品规格和质量约束。

---

## skills/ —— 技能副本区（五批 18 个）

本目录里的技能是从记录来源整理的**副本**，用来导入 Multica，避免在导入时到处找路径。

| 批次 | 数量 | 技能 |
|---|---|---|
| 第一批（必装） | 6 | daily-self-media-operator、ai-trust-content、manju-drama-studio、daihuo-product-video、zhipian-behind-scenes、zimeiti-data-ledger |
| 第二批（抖音线） | 6 | douyin-workflow-orchestrator、douyin-video-selection、douyin-video-production、douyin-caption-cover、douyin-publish-operator、douyin-fruit-commerce-strategy |
| 第三批（漫剧线） | 4 | mini-tiangong-drama、novel-to-tiangong-manju、chinese-celestial-palace、sd2.5-tiangong-manju |
| 第四批（AIGC 比赛抽卡） | 1 | mxai-contest-draw |
| 第五批（鲸歌计划资产抽卡） | 1 | mj-asset-card-drawer |

导入顺序与智能体挂载方式见 `05_阶段1_技能与智能体.md`。

---

## projects/天宫漫剧/ —— 漫剧社主线项目控制台

《西游之重铸天庭》天宫漫剧的控制台。**只新增索引层，不搬动原始生产目录**，避免破坏已有路径引用。

| 项目身份 | 值 |
|---|---|
| 项目 ID（不可变） | `tiangong-rebuild-v1` |
| 权威状态文件 | `projects/天宫漫剧/project_state.yaml` |
| 状态 | in_production（漫剧社主线，已从「待清理」恢复） |

控制台内部分区：

- `scripts/` —— 三集剧本、剧情精华、结构、审核简报
- `storyboard/` —— 上/中/下三集完整分镜与分镜台账
- `prompts/` —— 出图提交卡（第一批/第二批）+ M01–M17 资产提示词
- `assets/` —— 验收图索引、原作全文、风格锚
- `rendered/上集|中集|下集/` —— 每集 6 段 Seedance 2.5 成片提示词 + 该集资产图索引（可直接导入生产）

**项目身份判定只认 `project_id` + `project_state.yaml`，禁止用线程标题判定项目。**

> 注意：`E:\codex\multica` 可写；自媒体资产与天宫漫剧原始生产目录 `E:\codex\niannianai\...` 为**只读引用**，本工作区只放副本与索引。

---

## 历史项目与技能资料

`00_审计报告.md`、`02_创收路径.md`、`03_上手清单.md` 和后续阶段操作卡保留旧工作区的历史背景与专项操作内容。它们可能包含过时的路径、产品能力或步骤，不作为本地抽卡工作台的当前操作指引。新任务按本 README 顶部的入口、`PROJECT_CONTEXT.md`、`CONSTRAINTS.md` 和 `docs/` 中的现行规格与验收执行。

技能与漫剧资料用于专项任务，导入或使用前需核对其真源、项目状态和当次授权。**共同安全边界**：

- 不登录、不代发、不自动发布到任何平台。
- 发布必须由你本人当次明确授权。
- 付费生成按批次授权，每批只问一次，你保留最终审美确认权。
- 只记真实后台数字，缺失标「缺」，不猜测不编造。
- 不把 Cookie、Token、API Key、密码、证书、`.env` 写进本目录。

---

## 历史项目外部引用

以下位置来自既有项目资料，不是当前工作台的运行依赖；路径和内容仅作历史引用，使用前须重新核验。

| 目录 | 关系 |
|---|---|
| `E:\codex\niannianai\zimeiti` | **原料库**。内容草稿、成片、账号战略、技能、数据台账都在那边，本目录只放副本和索引，不替代它 |
| `E:\codex\niannianai\zhuanhuiyuangong\_旧剧隔离_20260907_待清理\西游之重铸天庭` | **天宫漫剧原始生产目录**。只读引用，本目录通过 `projects/天宫漫剧/` 建立索引层 |
| `E:\WORKBUDDY\Claw\SOP\multica-workspaces` | **Multica 的执行现场**。任务运行时的工作目录，由 Multica 自动管理 |
| `C:\Users\lsb\.multica` | **Multica 的本地配置与日志**。含密钥，只读不改不复制 |

本仓库当前还维护工作台源码、构建与验证入口；旧项目资料仍按只读引用或副本管理。
