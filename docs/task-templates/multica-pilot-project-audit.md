# Multica 试跑任务包：项目状态一致性审计

下面内容可直接粘贴到 Multica Issue。它只做仓库内只读审计，不触发平台登录、发布或付费调用。

## 元数据

- 风险等级：L1
- 责任角色：自媒体主控
- 备用角色：内容生产
- 项目身份：`tiangong-rebuild-v1`（不可变，禁止用任务标题判定项目）
- 输出模式：创建任务并留下审计回执

## 目标

把项目状态一致性审计作为第一条低风险试跑任务交给 Multica，验证「创建任务 → 自动执行 → 正常收尾」这条闭环，并留下可复核的审计回执。

## 输入

- `PROJECT_CONTEXT.md`、`CONSTRAINTS.md`；
- `docs/project-state-contract.md`；
- `projects/天宫漫剧/project_state.yaml`、`projects/天宫漫剧/README.md`、`projects/README.md`；
- 仓库内只读访问，不扫描无关目录。

## 输出

1. 逐项 PASS/FAIL 审计表；
2. 每项对应的文件或命令证据；
3. 不一致项、影响范围和修复建议；
4. 待用户拍板事项；
5. 保存到项目 `receipts/` 目录的回执草稿。

## 硬约束

- 不登录任何平台；
- 不发布内容；
- 不触发出图、出视频或其他付费调用；
- 不修改项目业务资产和状态文件；
- 不编造缺失数据，缺失字段写「缺」。

## 验收

- [ ] Issue 有明确的 `project_id`；
- [ ] 智能体读取最小上下文，而不是扫描无关目录；
- [ ] 输出包含证据而不是只有结论；
- [ ] `npm run verify` 通过；
- [ ] 没有外部副作用；
- [ ] 用户确认后，才允许把回执标记为 accepted。

## 失败处理

- 运行悬挂或无人收尾：检查本地执行器与代理状态，保留原任务，不重复派发；
- 缺少最小上下文或项目 ID：停止并输出缺失项，不用猜测补齐；
- 审计发现不一致：只报告差异和影响范围，不擅自改状态。

## 任务正文（可直接粘贴到 Multica Issue）

```text
你正在执行 Multica 工作区的第一条低风险试跑任务。

项目身份：tiangong-rebuild-v1
请先读取：
1. PROJECT_CONTEXT.md
2. CONSTRAINTS.md
3. docs/project-state-contract.md
4. projects/天宫漫剧/project_state.yaml
5. projects/天宫漫剧/README.md
6. projects/README.md

目标：只读审计项目状态、项目索引、交付物路径和授权边界是否一致。

请检查：
- project_id 是否在状态文件、项目 README、projects/README.md 中一致；
- status 是否属于契约允许枚举；
- source_of_truth、deliverables、blockers、authorization、paths、red_lines 是否齐全；
- deliverables 中列出的仓库内路径是否存在；
- blockers 是否与 asset_state.pending_review 混淆；
- 是否明确“不登录、不发布、不触发付费生成”。

输出：
1. 一份逐项 PASS/FAIL 审计表；
2. 每项对应的文件或命令证据；
3. 不一致项、影响范围和修复建议；
4. 下一步需要用户拍板的事项。

禁止：
- 不登录任何平台；
- 不发布内容；
- 不触发出图、出视频或其他付费调用；
- 不修改项目业务资产；
- 不编造缺失数据。

完成前运行 npm run verify，并在项目 receipts/ 目录保存回执草稿。
``` 

## 使用方式

1. 把「任务正文」整段粘贴到 Multica Issue，指派给目标智能体；
2. 按上面「验收」逐条核对，全部满足才算这条试跑通过；
3. 回执草稿经用户确认后才标记为 accepted，未确认前保持 `in_review`。
