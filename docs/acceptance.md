# 当前版本验收清单

## A. 规范完整性

- [ ] `AGENTS.md`、`CONSTRAINTS.md`、`PROJECT_CONTEXT.md` 存在且非空。
- [ ] `docs/INDEX.md`、`product-spec.md`、`architecture.md`、`implementation-plan.md`、`acceptance.md` 存在。
- [ ] 至少有一条 ADR 记录本次架构选择。
- [ ] `docs/lifecycle.md` 为每个阶段定义输入、产物、责任人和进入条件。

## B. 架构与边界

- [ ] 文档明确控制台、规范层、资产层和外部执行现场的边界。
- [ ] 文档明确禁止凭据进入仓库。
- [ ] 文档明确发布、登录和付费生成需要用户当次授权。
- [ ] 文档明确原始生产目录只读引用。

## C. 可验证性

- [ ] `npm run verify` 退出码为 0。
- [ ] 删除一个必需文件后，验证命令退出码非 0。
- [ ] 在测试副本中加入明显凭据模式后，验证命令退出码非 0。
- [ ] 敏感信息扫描范围覆盖 `docs`、`projects`、`skills`、`skills-archive`、`reference`、`mj-automation`、`scripts`、`.github` 以及根目录文本文件。
- [ ] 依赖环境、运行时目录和生成媒体不参与扫描，扫描不会因超大文件或失效外部链接中断。
- [ ] Markdown 结构检查生效：空文件、无标题文件、代码围栏不配对均能阻断验证。
- [ ] `projects/*/project_state.yaml` 均含唯一不可变 `project_id`、有效状态和状态契约字段。
- [ ] 每个项目状态都能在 `projects/README.md` 找到，并有对应项目 README。

## E. 任务可执行性

- [ ] 生产任务模板包含输入、输出、红线、授权和验收条件。
- [ ] 复核任务模板明确“不登录、不发布、不代替用户确认”。
- [ ] 数据复盘和 Autopilot 任务模板明确真实数据与人工授权边界。
- [ ] 现有阶段操作卡已在 `docs/task-templates/stage-map.md` 登记。
- [ ] 阻塞时保留 `blocked` 状态和解除条件，不用默认值掩盖缺失输入。

## F. 发布与复盘

- [ ] 发布前执行 `docs/release-checklist.md`。
- [ ] 发布成功有用户提供的最终平台回执。
- [ ] 阶段结束使用 `docs/retro-template.md`，缺失数据标记为「缺」。

## G. 首条试跑

- [ ] 至少有一份项目状态一致性审计回执保存在项目 `receipts/` 目录。
- [ ] 回执明确记录没有登录、发布或付费生成等外部副作用。
- [ ] Multica 试跑任务包包含项目 ID、最小上下文、验收和禁止事项。

## D. 交付纪律

- [ ] 未声称完成任何未由用户确认的发布动作。
- [ ] 没有新增平台登录、自动发布或付费调用。
- [ ] 现有资产路径未被搬迁。

## H. 版本控制

- [ ] 仓库已纳入 Git 版本控制，`.gitignore` 与 `.gitattributes` 存在。
- [ ] `git status` 中没有 `.venv`、`__pycache__`、运行时日志或生成媒体。
- [ ] 待提交文件中没有凭据、Token、Cookie 或证书。
- [ ] 被忽略的生成媒体在资产索引中有路径指针和 sha256，可追溯性不依赖仓库内二进制。
