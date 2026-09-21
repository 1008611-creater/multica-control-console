# 纳入版本控制回执

## 任务元数据

- 日期：2026-09-21
- 风险等级：L2（改变仓库基础设施，不触碰外部平台）
- 项目 ID：`tiangong-rebuild-v1`
- 使用模板：`docs/task-templates/project-state-audit.md`
- 责任角色：自媒体主控
- 外部动作：无登录、无发布、无付费生成

## 输入

- `PROJECT_CONTEXT.md`、`CONSTRAINTS.md`、`AGENTS.md`
- `docs/architecture.md`（第 7 节执行模式对照）
- 磁盘真实构成：`projects/` 101 文件 / 64.9 MB，`mj-automation/` 1769 文件 / 147.7 MB

## 执行内容

1. 新建 `.gitignore`，排除依赖环境、运行时日志、生成媒体和凭据。
2. 新建 `.gitattributes`，统一 LF 入库、`.cmd` 保持 CRLF、媒体声明为二进制。
3. 执行 `git init -b main`，仓库首次建立。
4. 提交前对全部待入库文件做敏感模式扫描。
5. 创建首次提交 `cc0aa3a`（302 个文件）。
6. 将 Multica `local_directory` 资源从 `in_place` 原地切换为 `worktree`。

## 关键判断：62.5 MB 验收候选图不入库

`projects/天宫漫剧/assets/验收图/第一批_MJ重出_20260913/` 的 13 个文件（62.5 MB）被排除，依据：

- 该目录定位是「索引与控制台」，项目 README 明确「图片文件本身留在原始生产目录，不搬动」。
- 逐文件 MD5 比对确认：13 张图全部与 `mj-automation/output/` 中的副本字节一致。
- 每张图的 sha256 已记录在 `assets/验收图/资产索引.md`，可追溯性不依赖仓库内的二进制。

## 验证证据

| 检查项 | 命令 | 结果 |
|---|---|---|
| 治理文件与状态契约 | `npm run verify` | PASS |
| 忽略规则生效 | `git check-ignore -v` | PASS（`.venv`、`run/`、`output/`、`archive/`、验收图目录均命中） |
| 待入库文件数 | `git status --porcelain -uall` | 301 个文件，合计 3.77 MB |
| 凭据扫描 | 对全部待入库文本文件匹配密钥模式 | PASS（唯一命中为函数参数名，非硬编码密钥） |
| 提交结果 | `git log --oneline` | `cc0aa3a`，工作区 CLEAN，跟踪 302 文件 |
| 资源模式切换 | `multica project resource update --execution-mode worktree` | PASS，`execution_mode` 现为 `worktree` |

## 结论

仓库已纳入版本控制，Multica 侧 `local_directory` 资源已切换为 `worktree` 模式。资源切换使用原地 `update`，未移除重建，历史绑定关系保留。

需要说明的边界：`worktree` 模式不会把被忽略的媒体纳入版本控制，验收候选图仍以「外部真源 + 索引 sha256」的方式追溯。

## 下一步

1. 由用户复核 ANS-21 的闭环结果（任务当前为 `in_review`）。
2. 由用户拍板 M01–M06、M09、M10 共 8 张已出图资产，这是项目自身的业务门槛。
