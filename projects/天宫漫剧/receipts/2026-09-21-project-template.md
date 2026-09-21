# 可复制项目模板回执

## 任务元数据

- 日期：2026-09-21
- 风险等级：L2（新增顶层目录，改变架构边界，不触碰外部平台）
- 项目 ID：`tiangong-rebuild-v1`
- 使用模板：`docs/task-templates/project-state-audit.md`
- 责任角色：自媒体主控
- 外部动作：无登录、无发布、无付费生成

## 输入

- 参考架构结论：真正值得做的不是继续堆技能，而是建立可复制的项目模板
- 本仓库 Slice 1-12 已经跑通的治理骨架
- `docs/architecture.md`、`docs/acceptance.md`、`scripts/verify.ps1`

## 执行内容

1. 新增 `templates/README.md`，说明两种使用路径：整体复制新工作区骨架，或在本仓库内新增项目控制台。
2. 新增 `templates/project-template/`，作为独立复制单元，包含：
   - 规范文件：`AGENTS.md`、`CONSTRAINTS.md`、`PROJECT_CONTEXT.md`
   - 文档骨架：`docs/INDEX.md`、`product-spec.md`、`architecture.md`、`implementation-plan.md`、`acceptance.md`
   - 决策记录：`docs/adr/0001-repository-boundary.md`
   - 验证入口：`scripts/verify.ps1`、`package.json`
   - 自动化与忽略规则：`.github/workflows/ci.yml`、`.gitignore`
3. 验证脚本的必需文件清单与扫描范围同时纳入 `templates/`，避免模板成为新的扫描盲区。
4. `docs/architecture.md` 新增模板层边界，明确模板内的规范文件不约束本仓库。

## 验证证据

| 检查项 | 方式 | 结果 |
|---|---|---|
| 本仓库治理 | `npm run verify` | PASS，退出码 0 |
| 模板可独立复制使用 | 复制到仓库外临时目录后运行模板自带验证脚本 | PASS，退出码 0 |
| 模板缺文件能拦截 | 临时移除 `docs/acceptance.md` 后运行 | FAIL 如期触发，提示缺失必需文件 |
| 模板凭据扫描生效 | 植入凭据模式文本后运行 | FAIL 如期触发，提示检测到潜在凭据模式 |
| 工作区状态 | `git status` | 只有本次受控改动，无临时探针残留 |

## 结论

模板骨架已可在仓库外独立复制并通过自检，缺失文件和凭据两种失败路径都被真实触发过，不是空跑。

边界说明：模板中的 `AGENTS.md` 属于被复制出去的新工作区，本仓库仍以根目录 `AGENTS.md` 为准；模板不承载真实项目数据，也未复制任何媒体或凭据。

## 下一步

1. 由用户复核 ANS-21 的闭环结果。
2. 由用户拍板 M01-M06、M09、M10 共 8 张已出图资产。
3. 下一批生产任务开跑前，先用模板建立对应项目的控制台骨架，再进入内容生产。
