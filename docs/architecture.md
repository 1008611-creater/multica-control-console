# 架构说明

## 1. 分层

```text
┌──────────────────────────────────────────┐
│  Multica 任务层                           │
│  Issues / Agents / Squads / Autopilots   │
└───────────────────┬──────────────────────┘
                    │ 任务输入、状态和产物
┌───────────────────▼──────────────────────┐
│  工作区规范层                             │
│  PROJECT_CONTEXT / product-spec /         │
│  CONSTRAINTS / acceptance / ADR           │
└───────────────────┬──────────────────────┘
                    │ 验证与索引
┌───────────────────▼──────────────────────┐
│  控制台资产层                             │
│  skills / projects / reference / docs     │
└───────────────────┬──────────────────────┘
                    │ 只读引用/人工交付
┌───────────────────▼──────────────────────┐
│  外部执行现场                             │
│  Multica runtimes / 原始生产目录 / 平台  │
└──────────────────────────────────────────┘
```

## 2. 依赖方向

```text
任务模板 → 规范与约束 → 技能/项目索引 → 外部执行现场
```

反向依赖禁止：技能不得修改根级约束；项目控制台不得把平台凭据写回仓库；外部执行现场的日志不得成为产品规格的唯一事实来源。

## 3. 状态模型

```text
idea → specified → planned → in_progress → awaiting_review
                                      ├→ accepted → shipped → measured
                                      └→ blocked → replanned
```

- `specified`：目标、边界和验收条件明确。
- `planned`：任务拆成可独立验证的垂直切片。
- `awaiting_review`：产物完成但尚未由用户确认。
- `accepted`：验收证据齐全。
- `shipped`：用户完成外部发布或交付；无用户回执不得进入此状态。
- `measured`：真实数据已回填，允许复盘。
- `blocked`：存在明确阻塞原因和下一步，不等同于失败。

## 4. 外部边界

本仓库只做索引、调度设计、规范、验证和结果沉淀。Multica 桌面端负责任务执行；平台 App 由用户本人操作。任何跨边界动作必须有明确授权和可回溯证据。

## 5. 失败与回滚

- 验证失败：保留失败证据，修复后重新运行验证。
- 任务执行失败：不覆盖上一次可用产物，记录失败原因和重试条件。
- 状态误更新：以 `project_state.yaml` 为准，提交一条带日期的状态修复记录。
- 外部发布失败：状态保持 `awaiting_review`，不得写成 `shipped`。

## 6. 契约入口

- 项目身份与生命周期：`docs/project-state-contract.md`。
- Multica 任务输入：`docs/task-templates/`。
- 自动检查：`scripts/verify.ps1`。
- 新工作区起点：`templates/project-template/`。

## 6.1 模板层

`templates/` 是本仓库的「可复制起点」层，不属于运行中的控制台内容。它保存经过验证的骨架，供新工作区整目录复制。

| 类别 | 位置 | 性质 |
|---|---|---|
| 新工作区骨架 | `templates/project-template/` | 独立复制单元；复制后成为新仓库的根 |
| 本仓库内的 Multica 任务模板 | `docs/task-templates/` | 本仓库运行时使用，不是复制单元 |

边界规则：

- 模板内的 `AGENTS.md` 属于被复制出去的新工作区，不约束本仓库；本仓库仍以根目录 `AGENTS.md` 为准。
- 模板不是真源。骨架改进先在本仓库验证，再同步到模板，禁止只改模板而让本仓库规范漂移。
- `templates/` 参与敏感信息与 Markdown 结构扫描，不得存放凭据、真实项目数据或运行时产物。

## 6.2 技能副本层

`skills/` 是**在役可导入**的技能副本区，`skills-archive/` 是**封存**区。两者都不是技能真源。

| 目录 | 性质 | 索引 |
|---|---|---|
| `skills/` | 在役副本，供导入 Multica | `skills/README.md` |
| `skills-archive/` | 封存副本，只归档不导入 | `skills-archive/转绘线/00_归档说明.md` |

边界规则：

- 真源在各外部技能库（`.workbuddy/skills`、`.codex/skills`、自媒体工作区）；副本与真源不一致时必须写明原因。
- 每个 `SKILL.md` 只允许一段 YAML frontmatter，`name` 必须与所在目录一致；导入依赖该字段。
- 每个副本必须登记在其所在区的索引中：在役副本进 `skills/README.md`，封存副本进归档目录下的 `00_*.md`。新增副本未登记时验证失败。
- 技能副本入库不代表已授权执行：登录、发布、付费生成仍需用户当次明确授权。


## 6.3 脚本编码契约

本仓库的验证脚本由 Windows PowerShell 5.1 执行，它把**无 BOM** 的脚本按系统 ANSI 代码页解析。脚本里只要出现中文路径或中文字面量，就会被读成乱码，检查逻辑随之失效或误报。

规则：

- 含非 ASCII 字符的 `.ps1` 必须带 UTF-8 BOM；纯 ASCII 脚本不加 BOM。
- 该规则由 `scripts/verify.ps1` 与模板的验证脚本共同检查，缺 BOM 即阻断提交。
- 优先用动态发现替代中文字面量（例如按 `00_*.md` 匹配归档索引），BOM 只是兜底，不是鼓励把中文写进路径常量。


## 7. 本地目录绑定与执行模式

Multica Project 通过 `local_directory` 资源绑定本地工作目录。两种执行模式的实际差异：

| 模式 | 前置条件 | 并发 | 回滚保护 | 适用场景 |
|---|---|---|---|---|
| `in_place` | 无 | 同一时刻只允许一个运行 | 无 | 目录尚未纳入版本控制时的临时绑定 |
| `worktree` | 目录必须是 Git 仓库 | 每个运行独立工作树，可并行 | 有 Git 历史可回滚 | 已纳入版本控制的常规开发 |

当前 `E:\codex\multica` 已于 2026-09-21 纳入 Git 版本控制（`main` 分支，首次提交 `cc0aa3a`），Multica 侧的 `local_directory` 资源同步切换为 `worktree` 模式（资源 ID `ab12f758-44ca-4562-b74d-74bf6a3c2910`）。

切换通过 `multica project resource update --execution-mode worktree` 原地完成，不需要移除并重建资源，因此历史绑定关系得以保留。`worktree` 模式要求目标目录是 Git 仓库且工作区干净；首次提交时工作区为空，满足该前提。

绑定与执行状态依赖本地执行器：执行器停止时，任务会被派发但无法正常收尾，表现为长期 `running`。执行器在绑定的目录内运行时会在 `.multica\daemon_task_context.json` 留下任务标记，该标记存在期间，在仓库目录内直接执行 Multica CLI 会被判定为代理任务内部调用而报错。

## 8. 版本控制边界

仓库只跟踪可审计的控制台内容：规范文件、项目状态、索引、任务模板、回执、技能副本和 MJ 自动化脚本。

| 类别 | 处理 | 原因 |
|---|---|---|
| 规范、状态、索引、模板、回执 | 入库 | 需要变更历史和可复核性 |
| `skills/`、`skills-archive/`、`reference/` 副本 | 入库 | 可导入资产；真源仍在外部位置 |
| `mj-automation/scripts/` 等自动化脚本 | 入库 | 可审阅的自动化逻辑 |
| `.venv/`、`__pycache__/`、`node_modules/` | 忽略 | 可重建的依赖环境 |
| `mj-automation/run/`、`*.log` | 忽略 | 运行时日志，非审计证据 |
| `mj-automation/output/`、`archive/` | 忽略 | 生成媒体，体积大且可重新获取 |
| `projects/天宫漫剧/assets/验收图/第一批_MJ重出_20260913/` | 忽略 | 与 `mj-automation/output/` 字节一致，sha256 已记录在资产索引 |
| `.env`、证书、Cookie、Token | 忽略 | 凭据绝不入库 |

被忽略的媒体真源在外部执行现场；仓库通过 `assets/验收图/资产索引.md` 中的 sha256 和路径指针保持可追溯，而不是复制二进制。
