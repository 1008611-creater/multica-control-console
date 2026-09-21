# 可复制模板

这个目录保存可以整体复制出去的骨架，用来把工作区已经验证过的治理方式复用到新项目。

## 1. 新工作区骨架：project-template/

整目录复制到新的工作区根目录，替换尖括号占位符后即可作为新仓库的起点。

| 路径 | 作用 |
|---|---|
| `AGENTS.md` | 项目铁律、生命周期、变更规则、验证入口 |
| `CONSTRAINTS.md` | 质量、安全、风险分级 |
| `PROJECT_CONTEXT.md` | 当前事实、缺口、非目标 |
| `docs/INDEX.md` | 文档地图与阅读时机 |
| `docs/product-spec.md` | 目标、用户、范围、核心流程 |
| `docs/architecture.md` | 分层、依赖方向、外部边界、失败回滚 |
| `docs/implementation-plan.md` | 垂直切片计划与依赖 |
| `docs/acceptance.md` | 可验证的验收条件 |
| `docs/adr/` | 架构决策记录 |
| `scripts/verify.ps1` | 唯一验证入口：必需文件、敏感信息、Markdown 结构 |
| `package.json` | 把验证绑定到 `npm run verify` |
| `.github/workflows/ci.yml` | 提交与合并时自动跑同一套验证 |
| `.gitignore` | 凭据、依赖环境、运行时产物的排除规则 |

使用步骤：

1. 复制 `templates/project-template/` 到新工作区根目录。
2. 全文替换尖括号占位符，例如 `<项目名>`、`<仓库根目录>`。
3. 在 `docs/product-spec.md` 写下真实目标，在 `docs/acceptance.md` 写下可验证条件。
4. 运行 `npm run verify`，确认退出码为 0。
5. 建立首次提交，再接入远端或执行器。

注意：模板里的 `AGENTS.md` 是给新工作区用的真实规范文件，不是本仓库的规则。复制前不要在本仓库内按它行事。

## 2. 本仓库内新增项目控制台

新增项目不需要复制整仓骨架，按现有约定即可：

1. 新建 `projects/<项目名>/`，包含 `README.md`、`project_state.yaml`、`receipts/README.md`。
2. 在 `projects/README.md` 登记 `project_id`。
3. 按 `docs/project-state-contract.md` 填写状态契约字段。
4. 任务输入使用 `docs/task-templates/` 中的模板。

`npm run verify` 会检查项目目录、唯一 ID、状态枚举和契约字段是否齐全。
