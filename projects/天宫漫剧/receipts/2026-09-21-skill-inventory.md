# 技能副本索引与元数据修复回执

## 任务元数据

- 日期：2026-09-21
- 风险等级：L2（改变技能副本区契约与验证规则，不触碰外部平台）
- 项目 ID：`tiangong-rebuild-v1`
- 使用模板：`docs/task-templates/project-state-audit.md`
- 责任角色：自媒体主控
- 外部动作：无登录、无发布、无付费生成

## 输入

- `skills/` 与 `skills-archive/` 下 23 个 `SKILL.md` 的真实元数据
- 各外部技能库真源：`.workbuddy/skills`、`.codex/skills`、`E:\codex\niannianai\zimeiti\skills`
- `reference/自媒体资产/全局技能库索引.md`
- Multica 侧真实技能库状态

## 发现的缺口

1. `skills/` 定位是「可导入的技能副本区」，但没有 `README.md`，16 个技能的来源、用途和导入状态无任何记录。
2. 13 个技能副本的 `SKILL.md` 顶部有**重复的 YAML frontmatter 块**，且 `description` 被写成 `name: <技能名>`。
   涉及抖音线 6 个和转绘线 7 个。
3. 该损坏不是副本搬运造成：真源 `C:\Users\lsb\.workbuddy\skills` 与 `C:\Users\lsb\.codex\skills` 同样受损，
   同批 94 个技能受影响。本仓库只能修副本，真源修复需另行决策。

## 损坏的实际后果

用 YAML 解析器直接解析第一个 frontmatter 块：

| 文件 | 解析结果 |
|---|---|
| 抖音线 6 个、转绘线 7 个 | 解析失败：mapping values are not allowed here |
| 其他 10 个（第一批、漫剧线） | 解析正常 |

即：损坏文件在导入时取不到有效元数据，直接影响 Multica 技能导入。

## 执行内容

1. 新建 `skills/README.md`：登记三批 16 个技能的用途、真源、与真源关系和 Multica 导入状态，并写明元数据规范与刷新规则。
2. 修复 13 个副本：只删除重复的 frontmatter 块，保留最后一个正确块，正文与文件编码（无 BOM、CRLF 保留）不变。
3. 新增技能元数据校验，覆盖五项：frontmatter 存在且闭合、`name` 与 `description` 各一次、`name` 与所在目录一致、正文不得残留第二个 frontmatter 块。
4. 同步文档：`docs/architecture.md` 新增 6.2 技能副本层；`docs/INDEX.md` 登记新索引；`docs/acceptance.md` 新增 J 节；`docs/implementation-plan.md` 新增 Slice 15 并修正 Slice 14 的标题错位。

## 验证证据

| 检查项 | 方式 | 结果 |
|---|---|---|
| 全仓基线 | `npm run verify` | PASS，退出码 0 |
| 修复后元数据可解析 | YAML 解析 23 个 `SKILL.md` | 23/23 通过，0 个失败 |
| 修复是纯删除 | `git diff --numstat` | 13 个文件全部为 0 新增、共删除 95 行 |
| 重复块能拦截 | 在副本中注入重复 frontmatter 块 | FAIL 如期触发：has a duplicated frontmatter block |
| 缺 frontmatter 能拦截 | 删除副本 frontmatter | FAIL 如期触发：is missing YAML frontmatter |
| 名称不匹配能拦截 | 把 `name` 改成不存在的名字 | FAIL 如期触发：name does not match its directory |
| 缺描述能拦截 | 删除 `description` 行 | FAIL 如期触发：must declare exactly one description, found 0 |
| 未闭合能拦截 | 删除 frontmatter 结束标记 | FAIL 如期触发：frontmatter is not closed |
| 恢复后正常 | 探针副本还原后重跑 | PASS，退出码 0 |

以上探针均在仓库外快照副本中执行，真实仓库未受影响。

## 结论

技能副本区不再是无索引状态；13 个导入级损坏已修复并通过真实解析器验证。
元数据校验已进入质量门，同类损坏在提交前会被拦截。

## 未处理（需用户决策）

1. **真源损坏**：`.workbuddy/skills` 与 `.codex/skills` 下同批 94 个技能仍带重复 frontmatter 块。修复真源属外部范围，需用户授权后另行处理。
2. **16 个技能未导入 Multica**：Multica 技能库当前只有 `daily-sop-ops`。导入是人工操作，需用户按 `05_阶段1_技能与智能体.md` 执行。
3. **`chinese-celestial-palace` 副本与真源不一致**：副本按本项目需要改写了路由段，属有意差异，已在索引「与真源关系」列注明。

## 下一步

1. 由用户决定是否修复外部技能库真源。
2. 由用户按操作卡把 16 个技能导入 Multica。
3. 由用户复核 ANS-21 闭环结果并拍板 8 张已出图资产。
