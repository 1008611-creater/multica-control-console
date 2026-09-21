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

## 结论

仓库已纳入版本控制，`worktree` 执行模式所需的 Git 前提成立。Multica 侧的 `local_directory` 资源仍为 `in_place`，切换属外部状态变更，需用户确认后执行。

## 下一步

由用户决定是否将 Multica 资源切换为 `worktree` 模式以启用并行运行与变更回滚。
