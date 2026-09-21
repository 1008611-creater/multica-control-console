# 生命周期补全与质量门加固回执

## 任务元数据

- 日期：2026-09-21
- 风险等级：L2（改变模板层契约、验证规则与状态字段语义，不触碰外部平台）
- 项目 ID：`tiangong-rebuild-v1`
- 使用模板：`docs/task-templates/project-state-audit.md`
- 责任角色：自媒体主控
- 外部动作：无登录、无发布、无付费生成

## 输入

- 参考架构结论：真正值得做的是「可复制的项目模板」，而不是继续堆技能
- `templates/project-template/` 现有骨架与其 `AGENTS.md` 中的生命周期承诺
- `scripts/verify.ps1` 在真实运行中暴露的一次自身故障
- `docs/task-templates/multica-pilot-project-audit.md` 中对交付物路径的人工检查要求

## 发现的缺口

1. **验证器自身故障**：技能副本索引查找依赖中文字面量，而脚本没有 UTF-8 BOM，Windows PowerShell 5.1 按 ANSI 解析导致中文路径读坏，验证结果不可信。
2. **副本未登记无法拦截**：新增技能副本即使不写进索引也能通过验证，索引会随时间失效。
3. **模板只有阶段名、没有阶段门**：模板 `AGENTS.md` 承诺 DEFINE→RETRO 生命周期，却既没有阶段契约，也没有 SHIP 入口和 RETRO 产物。
4. **「已验收」可以是假话**：状态文件的 `deliverables[].path` 从未被自动校验，路径失效后仍能保持 `accepted`。

## 执行内容

1. 索引查找改为动态发现（按 `00_*.md` 匹配归档索引），不再依赖中文字面量；两个验证脚本补上 UTF-8 BOM。
2. 新增「含非 ASCII 字符的 `.ps1` 必须带 UTF-8 BOM」检查，并写入架构契约，防止同类故障复发。
3. 新增「技能副本必须登记在其所属索引中」检查，在役与封存两条路径都覆盖。
4. 模板补齐 `docs/lifecycle.md`、`docs/release-checklist.md`、`docs/retro-template.md`，并把三者加入模板验证脚本的必需文件清单。
5. 新增交付物路径真实性检查：遍历每个 `project_state.yaml` 的 `deliverables[].path`，路径不存在即失败并报出项目 ID。
6. 同步文档：`docs/architecture.md` 新增 6.3 脚本编码契约；`docs/acceptance.md` 补充对应验收项；`docs/project-state-contract.md` 增加第 6 条更新规则。

## 验证证据

| 检查项 | 方式 | 结果 |
|---|---|---|
| 全仓基线 | `npm run verify` | PASS，退出码 0 |
| 在役副本未登记能拦截 | 在 `skills/README.md` 中改名 | FAIL 如期触发：Skill copy is not registered in its index |
| 封存副本未登记能拦截 | 在归档说明中改名 | FAIL 如期触发：同上 |
| 无 BOM 脚本能拦截 | 去掉 BOM 后注入中文注释 | FAIL 如期触发：PowerShell script has non-ASCII text but no UTF-8 BOM |
| 交付物路径失效能拦截 | 把交付物路径改成不存在的文件 | FAIL 如期触发：Deliverable path does not exist in tiangong-rebuild-v1 |
| 模板缺生命周期契约能拦截 | 在模板副本中删除 `docs/lifecycle.md` | FAIL 如期触发：Missing or empty required files |
| 模板仍可独立使用 | 模板复制到仓库外运行自身验证脚本 | PASS，退出码 0 |
| 恢复后正常 | 探针副本还原后重跑 | PASS，退出码 0 |

以上探针均在仓库外快照副本中执行，真实仓库未受影响；探针目录已清理。

## 结论

模板层现在自带完整生命周期，新工作区第一天就有阶段门而不是只有阶段名。
验证器不再因自身编码问题误报，且「技能副本未登记」和「交付物路径失效」两类静默漂移都会在提交前被拦截。

## 未处理（需用户决策）

1. **上游真源损坏**：`.workbuddy/skills` 与 `.codex/skills` 下 94 个技能仍带重复 frontmatter 块，修复真源属外部范围。
2. **16 个技能未导入 Multica**：Multica 技能库当前只有 `daily-sop-ops`。
3. **`superpowers` 位置**：11 个技能实际装在 `.workbuddy/skills`，`.codex/skills` 下没有，Codex 侧不可调用。
4. **`addyosmani/agent-skills` 未安装**：三处技能库均未找到。

## 下一步

1. 由用户决定是否修复外部技能库真源、是否把 16 个技能导入 Multica。
2. 由用户复核 ANS-21 闭环结果并拍板 8 张已出图资产。
3. 资产拍板后即可编译 Seedance 2.5 提示词，进入真实生产切片。
