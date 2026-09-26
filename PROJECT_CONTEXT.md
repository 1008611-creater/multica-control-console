# PROJECT_CONTEXT

更新时间：2026-09-26

## 一句话定位

Multica 是内容生产与创收工作的任务编排层；本仓库是它的可审计控制台，连接技能副本、项目状态、任务模板和真实结果。

## 当前事实

- 工作区：`E:\codex\multica`
- Multica 工作目录：`E:\WORKBUDDY\Claw\SOP\multica-workspaces`
- 主线项目控制台：`projects/天宫漫剧/`
- 主线项目 ID：`tiangong-rebuild-v1`
- 主线项目状态真源：`projects/天宫漫剧/project_state.yaml`
- 当前生产规格：竖版 9:16、1080×1920；漫剧每集约 3.5 分钟。
- 外部原始生产目录只读引用，不在本仓库搬迁。

## 当前能力

- 现有技能副本、阶段操作卡和账号/项目资产索引已存在。
- 风险等级与生命周期阶段门见 `docs/risk-levels.md`；L1 及以上任务使用 `docs/task-templates/context-pack.md` 或项目输入包启动。
- Multica 的任务、智能体、运行时、小队和 Autopilot 通过外部桌面端执行。
- 本仓库没有传统应用运行时，因此质量门槛以文档、状态、索引和脚本验证为主。

## 当前缺口

历史缺口已在本轮治理重构中补齐。当前仍需持续维护的是：

1. 新项目必须登记到 `projects/README.md` 并提供状态契约；
2. 新任务必须从 `docs/task-templates/` 选模板；
3. 外部 Multica 执行结果需要持续回写真实证据。

## 本次重构目标

- 建立 `DEFINE → PLAN → BUILD → VERIFY → REVIEW → SHIP → RETRO` 生命周期。
- 把长期工程约束与当前版本验收条件分离。
- 让每次任务都能用最小上下文启动，并以证据结束。
- 保留现有资产和路径，避免破坏已经可用的生产引用。

## 非目标

- 不重写 Multica 客户端或运行时。
- 不自动登录、发布、付费生成或抓取平台后台。
- 不搬迁外部原始生产目录。
- 不在没有真实需求和验收证据的情况下新增技能或智能体。
