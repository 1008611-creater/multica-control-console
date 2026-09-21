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

## Slice 13 · 可复制项目模板（已完成）

- 修改：`templates/`、`scripts/verify.ps1`、`docs/architecture.md`、`docs/INDEX.md`、`docs/acceptance.md`、`docs/adr/0002-project-template-layer.md`
- 输入：本仓库 Slice 1-12 已经验证过的治理骨架，以及参考架构中「建立可复制项目模板」的结论
- 输出：`templates/project-template/` 整目录复制单元，含规范文件、`docs/` 骨架、ADR 示例、验证脚本、CI 与忽略规则
- 验证：把模板复制到仓库外的新目录后运行验证脚本 → PASS；删除必需文件 → 退出码非 0；植入凭据模式 → 退出码非 0
- 完成条件：新项目不必从零拼装治理骨架，且模板本身处于本仓库的扫描范围内

## Slice 14 · 防漂移检查（已完成）

- 修改：`scripts/verify.ps1`、`docs/acceptance.md`、`docs/implementation-plan.md`
- 输入：Slice 12-13 建立的扫描范围与模板层，以及文档中出现的大量跨文件引用
- 输出：新增两项检查——Markdown 相对链接必须指向真实文件；项目状态的 `paths.control_console` 必须与项目控制台实际位置一致
- 验证：在真实副本中植入断链 → 退出码非 0；把 `control_console` 改指向错误目录 → 退出码非 0；恢复后 → PASS
- 完成条件：文档重构或项目迁移后留下的失效引用能在提交前被拦截，而不是等到使用时才发现

## Slice 15 · 技能副本索引与元数据校验（已完成）

- 修改：`skills/README.md`、`scripts/verify.ps1`、`docs/architecture.md`、`docs/INDEX.md`、`docs/acceptance.md`
- 输入：`skills/` 与 `skills-archive/` 下 23 个 `SKILL.md` 的真实元数据，以及各外部技能库真源
- 输出：技能副本索引；新增技能元数据校验——frontmatter 必须存在且闭合、`name` 与 `description` 各一次、`name` 与所在目录一致、正文不得残留第二个 frontmatter 块
- 修复：13 个副本的重复 frontmatter 块（抖音线 6 个、转绘线 7 个），只删除重复块，正文与编码未变
- 验证：`npm run verify` → PASS；在副本中注入重复块、缺 frontmatter、`name` 不匹配、缺 `description`、frontmatter 未闭合 → 退出码均为非 0
- 完成条件：技能副本不再处于无索引状态，损坏的元数据在提交前被拦截

## Slice 16 · 脚本编码契约与索引登记检查（已完成）

- 修改：`scripts/verify.ps1`、`templates/project-template/scripts/verify.ps1`、`docs/architecture.md`、`docs/acceptance.md`
- 输入：Slice 15 的技能副本检查，以及在真实运行中暴露的一次验证器自身故障
- 输出：两项新检查——技能副本必须登记在其所属索引中；含非 ASCII 字符的 `.ps1` 必须带 UTF-8 BOM
- 修复：技能副本索引查找改为动态发现，不再依赖中文字面量；两个验证脚本补上 UTF-8 BOM
- 验证：`npm run verify` → PASS；索引改名 → FAIL；探针脚本去掉 BOM 并加中文 → FAIL；模板在仓库外复制后 → PASS
- 完成条件：验证器不再因自身编码问题误报，且新增技能副本未登记时无法通过提交

## 依赖与风险

- Slice 3 依赖 Slice 2，否则状态文件可能被误判为有效。
- Slice 4 依赖 Slice 1 的边界，否则容易把自动发布误写进模板。
- Slice 5 依赖项目状态契约；新增项目必须先登记 `projects/README.md`。
- 不在本次范围内重写外部生产目录或 Multica 客户端。
