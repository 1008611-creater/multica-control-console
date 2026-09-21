# 验收清单章节顺序检查回执

## 任务元数据

- 日期：2026-09-21
- 风险等级：L2（改变跨目录验证契约，不触碰外部平台）
- 项目 ID：`tiangong-rebuild-v1`
- 使用模板：`docs/task-templates/project-state-audit.md`
- 责任角色：自媒体主控
- 外部动作：无登录、无发布、无付费生成

## 输入

- `docs/acceptance.md` 与 `templates/project-template/docs/acceptance.md`
- `scripts/verify.ps1`、`templates/project-template/scripts/verify.ps1`

## 发现的缺口

验收清单用 A/B/C 字母定位条款，但本仓库的章节实际顺序是 A/B/C/E/F/G/D/H/I/J：D 节「交付纪律」被插到了 G 节之后。字母乱序会让「D 节」这类指代出现两个候选位置，读者容易漏读交付纪律条款；验证脚本此前只检查文件存在，不检查内部结构顺序。

## 执行内容

1. 把 D 节移回 C 节之后，恢复 A→J 的字母顺序。
2. `scripts/verify.ps1` 新增验收清单顺序检查：读取所有 `## X. 标题` 形式的章节字母，必须严格升序，乱序即失败。
3. `templates/project-template/scripts/verify.ps1` 加入同一检查，使新项目第一天就有这层保护。
4. `docs/acceptance.md` C 节补充对应验收项；`docs/implementation-plan.md` 新增 Slice 20。

## 验证证据

| 检查项 | 方式 | 结果 |
|---|---|---|
| 全仓基线 | `npm run verify` | PASS，退出码 0 |
| 主仓乱序能拦截 | 快照副本中把 D 节移回 G 之后 | FAIL 如期触发，提示章节乱序 |
| 模板乱序能拦截 | 快照副本中把 A 节移到最后 | FAIL 如期触发 |
| 模板独立复制后仍生效 | 单独复制 `templates/project-template` 后重排章节 | FAIL 如期触发 |
| 恢复后正常 | 快照副本还原后重跑 | PASS，退出码 0 |
| 模板自带验证 | 直接运行模板验证脚本 | PASS，退出码 0 |

## 结论

条款定位所依赖的字母编号不再可能静默错乱。检查同时覆盖本仓库与可复制模板，模板复制到仓库外后依然有效。

## 下一步

1. 由用户拍板是否按阶段 1 操作卡建四个角色智能体与一个小队，或复用现有三个智能体只补技能挂载。
2. 由用户拍板 16 个技能是否导入，以及上游真源的重复 frontmatter 损坏如何处理。
3. 执行器当前停止，若要继续跑 Multica 任务需先启动。
4. `ANS-21` 仍为 `in_review`，需人工复核后归档。
