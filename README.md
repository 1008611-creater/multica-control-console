# multica 创收工作区

建立日期：2026-09-11
工作目录：E:\codex\multica
定位：**专门用于「借助 Multica 产出内容并赚到钱」的工作区**。

---

## 这个文件夹是干什么的

把三样东西接在一起：

1. **Multica**（AI 智能体编排平台）——负责调度、分配任务、自动排期、留痕。
2. **已有的自媒体资产**（念念家族账号矩阵、内容技能、成片与草稿、IP 世界观、天宫漫剧三集素材）——负责提供真正能变成钱的内容。
3. **创收动作**（发内容涨粉变现、接单代做、卖技能资产）——负责收钱。

一句话：**Multica 是工厂，自媒体资产是原料和产线，这里是总调度室。**

---

## 目录结构

| 位置 | 内容 |
|---|---|
| `README.md` | 本文件，项目章程与使用说明 |
| `PROJECT_CONTEXT.md` | 当前技术栈、事实、缺口和非目标 |
| `AGENTS.md` | 项目级工作流、依赖方向和变更纪律 |
| `CONSTRAINTS.md` | 长期质量、安全、权限和风险分级 |
| `docs/` | 产品规格、架构、实施计划、验收清单和 ADR |
| `scripts/verify.ps1` | 统一质量门禁；通过 `npm run verify` 执行 |
| `projects/README.md` | 项目控制台与状态真源索引 |
| `00_审计报告.md` | Multica 是什么 + 本机现状 + 资产盘点 + 缺口风险 |
| `01_资产索引.md` | 所有相关路径、用途、复用价值一览 |
| `02_创收路径.md` | 五条候选变现路线、优先级、第一步动作 |
| `03_上手清单.md` | **主行动清单：阶段 0–5 照着做** |
| `04_阶段0_唤醒Multica.md` | 阶段 0 当日操作卡：代理 → 运行时可用 → 并发 1 改 3 |
| `05_阶段1_技能与智能体.md` | 阶段 1 操作卡：三批技能导入 + 4 个智能体 + 1 个小队 |
| `06_阶段2_Autopilot.md` | 阶段 2 操作卡：4 条自动排期 |
| `07_阶段4_三成片发布清单.md` | 阶段 4 操作卡：三条成片统一发布 + 数据闭环 |
| `skills/` | **技能副本区**：三批共 16 个技能，直接从本目录导入 Multica |
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

## skills/ —— 技能副本区（三批 16 个）

本目录里的技能是从全局技能库复制进来的**副本**，用来直接导入 Multica，避免在导入时到处找路径。

| 批次 | 数量 | 技能 |
|---|---|---|
| 第一批（必装） | 6 | daily-self-media-operator、ai-trust-content、manju-drama-studio、daihuo-product-video、zhipian-behind-scenes、zimeiti-data-ledger |
| 第二批（抖音线） | 6 | douyin-workflow-orchestrator、douyin-video-selection、douyin-video-production、douyin-caption-cover、douyin-publish-operator、douyin-fruit-commerce-strategy |
| 第三批（漫剧线） | 4 | mini-tiangong-drama、novel-to-tiangong-manju、chinese-celestial-palace、sd2.5-tiangong-manju |

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

## 怎么用

**第一次进来**：先读 `00_审计报告.md`，再读 `02_创收路径.md`。

**每次要干活**：读 `03_上手清单.md`，执行当前阶段那几步。

**红线（继承自媒体工作区，不放松）**：

- 不登录、不代发、不自动发布到任何平台。
- 发布必须由你本人当次明确授权。
- 付费生成按批次授权，每批只问一次，你保留最终审美确认权。
- 只记真实后台数字，缺失标「缺」，不猜测不编造。
- 不把 Cookie、Token、API Key、密码、证书、`.env` 写进本目录。

---

## 与其它目录的关系

| 目录 | 关系 |
|---|---|
| `E:\codex\niannianai\zimeiti` | **原料库**。内容草稿、成片、账号战略、技能、数据台账都在那边，本目录只放副本和索引，不替代它 |
| `E:\codex\niannianai\zhuanhuiyuangong\_旧剧隔离_20260907_待清理\西游之重铸天庭` | **天宫漫剧原始生产目录**。只读引用，本目录通过 `projects/天宫漫剧/` 建立索引层 |
| `E:\WORKBUDDY\Claw\SOP\multica-workspaces` | **Multica 的执行现场**。任务运行时的工作目录，由 Multica 自动管理 |
| `C:\Users\lsb\.multica` | **Multica 的本地配置与日志**。含密钥，只读不改不复制 |

本目录只做三件事：**索引、调度设计、成果沉淀**。
