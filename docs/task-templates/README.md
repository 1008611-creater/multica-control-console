# 任务模板

模板用于给 Multica Issues、Squads 和 Autopilots 提供最小完整上下文。每个模板都必须包含：

1. 目标与项目 ID；
2. 输入与事实来源；
3. 输出物和路径；
4. 红线与授权要求；
5. 验收条件与失败处理；
6. 风险等级和责任角色。

模板是任务输入，不是自动授权。任何发布、登录或付费生成都必须停在人工确认门。

以上六项由 `npm run verify` 自动检查：带「元数据」段的任务模板缺少目标、输入、输出、硬约束、验收或失败处理任一节，以及未声明风险等级或责任角色时，验证都会失败。`stage-map.md` 属于映射文档，不参与该检查。

现有模板：

- `content-production.md`：从已确认选题生成脚本、素材清单和发布包草稿。
- `review-and-release.md`：整理发布准备、合规检查和用户确认卡，不执行发布。
- `data-review.md`：记账、缺失字段处理和周复盘。
- `autopilot.md`：创建派工任务，不执行发布或付费调用。
- `stage-map.md`：将旧阶段操作卡映射到新模板。
- `project-state-audit.md`：审计项目身份、状态、交付物和授权边界。
- `multica-pilot-project-audit.md`：可直接粘贴到 Multica 的第一条低风险试跑任务包。
- `aigc-contest-draw.md`：为 AIGC 比赛准备国内版 Midjourney 抽卡批次，付费出图前必须停在人工授权。
- `problem-brief.md`：DEFINE 阶段的固定产物，先锁定用户、问题、非目标和成功判据。
- `review-report.md`：REVIEW 阶段的固定产物，用证据把 blocking 问题收敛到 0。
