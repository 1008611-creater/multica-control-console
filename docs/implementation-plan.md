# 实施计划

## Slice 1 · 建立治理骨架（已完成）

- 修改：`AGENTS.md`、`CONSTRAINTS.md`、`PROJECT_CONTEXT.md`、`docs/*`
- 输入：现有 README、审计报告、阶段操作卡、项目状态文件
- 输出：统一生命周期、边界、验收条件和 ADR
- 验证：`npm run verify`
- 完成条件：规范文件齐全，内容指向当前真实路径，不引入凭据

## Slice 2 · 统一验证入口（已完成）

- 修改：`package.json`、`scripts/verify.ps1`、`.github/workflows/ci.yml`
- 输入：Slice 1 的必需文件和安全约束
- 输出：本地与 CI 使用同一验证命令
- 验证：PowerShell 直接运行与 `npm run verify`
- 完成条件：缺文件、空文件、敏感模式、失效主线状态均能失败

## Slice 3 · 项目状态契约（已完成）

- 修改：`projects/*/project_state.yaml`、`docs/project-state-contract.md`
- 输入：现有项目状态和资产台账
- 输出：统一字段：项目 ID、状态、来源、交付物、阻塞、授权记录
- 验证：YAML 契约检查 + 项目定向检查
- 完成条件：主线项目由不可变 ID 定位，状态字段可由验证器检查

## Slice 4 · 任务模板化（已完成第一版）

- 修改：`docs/task-templates/`
- 输入：已确认的产品规格与约束
- 输出：选题、生产、发布准备、数据复盘模板
- 验证：每个模板都包含输入、输出、红线、验收条件
- 完成条件：生产和复核任务都有输入、输出、红线和验收条件

## Slice 5 · 阶段卡迁移索引（已完成）

- 修改：`docs/task-templates/stage-map.md`、`projects/README.md`、项目 README
- 输入：现有阶段 0–4 操作卡和主线项目控制台
- 输出：阶段卡到模板的单一映射，所有项目由状态真源定位
- 验证：`npm run verify`
- 完成条件：新任务先使用模板，再按映射引用旧操作卡；不再新增未登记的流程入口

## Slice 6 · 多项目状态门禁（已完成）

- 修改：`scripts/verify.ps1`、`projects/README.md`、`docs/project-state-contract.md`
- 输入：所有 `projects/*/project_state.yaml`
- 输出：唯一 ID、项目 README、索引登记和状态字段的统一检查
- 验证：`npm run verify`
- 完成条件：任何新增项目缺少登记或契约字段都会阻断验证

## Slice 7 · 发布与复盘闭环（已完成）

- 修改：`docs/release-checklist.md`、`docs/retro-template.md`、`docs/acceptance.md`
- 输入：现有发布红线、真实数据台账规则和生命周期状态模型
- 输出：SHIP/RETRO 的固定产物与回滚条件
- 验证：`npm run verify`
- 完成条件：发布回执、状态回写和复盘证据均有明确入口

## Slice 8 · 生命周期阶段契约（已完成）

- 修改：`docs/lifecycle.md`、`docs/INDEX.md`、`docs/acceptance.md`
- 输入：参考架构的 DEFINE/PLAN/BUILD/VERIFY/REVIEW/SHIP/RETRO 生命周期
- 输出：每阶段输入、产物、责任人、进入条件和失败回退路径
- 验证：`npm run verify`
- 完成条件：中大型任务不能跳过验证或用隐含上下文进入下一阶段

## Slice 9 · 首条端到端试跑（已完成）

- 修改：`docs/task-templates/project-state-audit.md`、`projects/天宫漫剧/receipts/`
- 输入：主线项目状态、项目索引和状态契约
- 输出：项目状态一致性审计回执
- 验证：`npm run verify`
- 完成条件：回执可追溯、无外部副作用，下一步授权门明确

## Slice 10 · Multica 外部试跑任务包（已完成）

- 修改：`docs/task-templates/multica-pilot-project-audit.md`
- 输入：首条项目状态审计模板与真实控制台路径
- 输出：可直接粘贴到 Multica 的 Issue 正文和通过条件
- 验证：`npm run verify`
- 完成条件：外部试跑不需要临时拼接上下文，且不包含外部副作用授权

## Slice 11 · 纳入版本控制（已完成）

- 修改：`.gitignore`、`.gitattributes`、`docs/architecture.md`、`docs/implementation-plan.md`
- 输入：Slice 1–10 的控制台内容，以及 `projects/`、`mj-automation/` 的真实目录构成
- 输出：`main` 分支上的首次提交；依赖环境、运行时日志和生成媒体按规则排除
- 验证：`npm run verify` + 提交前敏感模式扫描 + `git status` 确认忽略规则生效
- 完成条件：控制台内容全部入库，凭据、`.venv`、运行时日志和 62.5 MB 生成媒体不入库；`worktree` 模式所需的 Git 前提成立

## Slice 12 · 质量门补强（已完成）

- 修改：`scripts/verify.ps1`、`docs/acceptance.md`、`docs/implementation-plan.md`
- 输入：Slice 2 的验证入口，以及 `AGENTS.md` 中对验证内容的承诺
- 输出：扫描范围覆盖全部受治理目录；补齐 Markdown 基本结构检查
- 验证：`npm run verify`；并在真实目录中植入凭据模式与未闭合代码围栏，确认退出码非 0
- 完成条件：`mj-automation/`、`scripts/`、`.github/` 不再处于扫描盲区，验证行为与文档承诺一致

## 依赖与风险

- Slice 3 依赖 Slice 2，否则状态文件可能被误判为有效。
- Slice 4 依赖 Slice 1 的边界，否则容易把自动发布误写进模板。
- Slice 5 依赖项目状态契约；新增项目必须先登记 `projects/README.md`。
- 不在本次范围内重写外部生产目录或 Multica 客户端。
