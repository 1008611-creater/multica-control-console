# 文档索引

| 文档 | 用途 | 何时阅读 |
|---|---|---|
| `product-spec.md` | 当前产品目标、用户、范围和核心流程 | 开始需求或新功能前 |
| `architecture.md` | 控制台、资产和 Multica 执行现场的边界 | 设计跨目录变更前 |
| `lifecycle.md` | DEFINE 到 RETRO 的输入、产物、责任和门槛 | 设计或执行中大型任务时 |
| `implementation-plan.md` | 本次重构和后续演进的垂直切片计划 | 开始实现前 |
| `acceptance.md` | 当前版本的可验证验收条件 | 交付前 |
| `release-checklist.md` | SHIP 阶段的发布、回执和回滚检查 | 交付前 |
| `retro-template.md` | RETRO 阶段的事实记录与复盘模板 | 发布或阶段结束后 |
| `project-state-contract.md` | 项目状态字段、状态转移和更新规则 | 修改 `project_state.yaml` 前 |
| `task-templates/` | 可复用的 Multica 任务输入模板 | 创建新任务前 |
| `task-templates/problem-brief.md` | DEFINE 阶段的问题简报产物 | 写规格或计划前 |
| `task-templates/review-report.md` | REVIEW 阶段的复核报告产物 | 交付或发布前 |
| `../templates/README.md` | 可复制的新工作区骨架与用法 | 开新项目或复用治理方式前 |
| `../projects/README.md` | 所有项目控制台与状态真源索引 | 新增或切换项目时 |
| `../skills/README.md` | 在役技能副本的批次、用途、真源与导入状态 | 导入技能或刷新副本前 |
| `adr/0001-workspace-governance.md` | 为什么采用控制台 + 外部执行现场 | 架构争议或边界变化时 |
| `adr/0002-project-template-layer.md` | 为什么新增可复制模板层 | 复用治理骨架或调整模板时 |

根级约束：

- `AGENTS.md`：项目铁律与工作方式
- `CONSTRAINTS.md`：长期质量、安全和风险分级
- `PROJECT_CONTEXT.md`：当前事实、缺口和非目标
