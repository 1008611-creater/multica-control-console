# PROJECT_CONTEXT

更新时间：2026-09-26

## 一句话定位

本仓库维护 Multica 本地抽卡生产工作台的源码、规则、运行与分发边界及可核验结果。目标产品面向 Windows、全中文，重点是可读的任务队列、最多三并发、真实回执、成品位置、失败原因和重提条件。

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
- [已验证，2026-09-26] Multica 本地任务与抽卡桥位于同一主机 `DESKTOP-OMI2AR3`；Issue `ANS-33` 能读取 AIGC 项目的 `project_state.yaml`，且 `GET /health` 返回 HTTP 200、`ok=true`。
- [已验证，2026-09-26] 项目绑定执行模式为 `worktree`；Multica 任务向主工作区回执路径写入被系统以 `UnauthorizedAccessException` 拒绝。测试结果见 `projects/AIGC比赛抽卡/receipts/multica-connectivity-test-2026-09-26.md`。
- 本仓库同时包含工作台应用源码和治理材料；桥接服务源码位于 `mj-automation/scripts/`，中文页面位于 `mj-automation/control/`，Windows 安装与构建脚本位于 `installers/`、`scripts/` 和根目录启动器。
- [已验证，2026-09-27] 主机内有本机运行依赖 `runtime/`、本地回执/任务数据和 `dist/` 分发件；它们不是同一种资产。具体版本控制和保留边界见 `docs/architecture.md`。
- [用户确认，2026-09-27] 本轮工程目标是围绕 Windows 本地抽卡工作台收敛，仓库中的历史技能和项目材料仅作为支持资产。
- [待验证] 队列、并发、回执、安装升级要求是否已在真实运行环境完整实现，须逐项按 `docs/acceptance.md` 验收；不能用产品规格或静态源码检查代替。

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
