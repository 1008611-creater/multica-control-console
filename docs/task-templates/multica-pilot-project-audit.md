# Multica 试跑任务包：项目状态一致性审计

下面内容可直接粘贴到 Multica Issue。它只做仓库内只读审计，不触发平台登录、发布或付费调用。

## Issue 元数据

- 标题：`[Pilot] 审计 tiangong-rebuild-v1 项目状态一致性`
- 项目 ID：`tiangong-rebuild-v1`
- 风险等级：L1
- 目标角色：自媒体主控
- 备用角色：内容生产
- 输出模式：创建任务并留下审计回执

## 任务正文

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

## 通过条件

- Issue 有明确的 `project_id`；
- 智能体读取了最小上下文，而不是扫描无关目录；
- 输出包含证据而不是只有结论；
- `npm run verify` 通过；
- 没有外部副作用；
- 用户确认后，才允许把回执标记为 accepted。
