# 技能副本索引

本目录保存**可导入 Multica 的技能副本**，不是技能真源。真源在各外部技能库，修改前先回到真源核对。

导入操作卡见 [05_阶段1_技能与智能体.md](../05_阶段1_技能与智能体.md)；技能名沿用原名，不得改名。

## 一、批次总览

| 批次 | 数量 | 技能 | 真源 | Multica 导入状态 |
|---|---|---|---|---|
| 第一批 · 核心 6 个 | 6 | 见下表 | `E:\codex\niannianai\zimeiti\skills\` | 未导入 |
| 第二批 · 抖音线 6 个 | 6 | 见下表 | `C:\Users\lsb\.workbuddy\skills\` | 未导入 |
| 第三批 · 漫剧线 4 个 | 4 | 见下表 | 混合，见下表 | 未导入 |

截至 2026-09-21，Multica 技能库只有 `daily-sop-ops` 一个技能，上表 16 个副本**均未导入**。

## 二、第一批 · 核心 6 个

真源：`E:\codex\niannianai\zimeiti\skills\<技能名>\`（6 个 `SKILL.md` 与副本字节一致）。

| 技能 | 用途 |
|---|---|
| `daily-self-media-operator` | 总调度：选题、脚本、发布包、合规、数据的分发中枢 |
| `ai-trust-content` | 念念AI社主理号信任内容生产线 |
| `manju-drama-studio` | 漫剧社运营协调：发布包、排期、合规、数据 |
| `daihuo-product-video` | 念念带货屋商品短视频生产线 |
| `zhipian-behind-scenes` | 念念制片厂生产线幕后内容 |
| `zimeiti-data-ledger` | 自媒体数据台账与周复盘 |

同批副本另存于 `../reference/自媒体资产/skills/` 目录，与真源一致。

## 三、第二批 · 抖音线 6 个

真源：`C:\Users\lsb\.workbuddy\skills\<技能名>\`，并同步存在于 `C:\Users\lsb\.codex\skills\`。

| 技能 | 用途 |
|---|---|
| `douyin-workflow-orchestrator` | 总控：串起选题 → 生产 → 包装 → 上传 |
| `douyin-video-selection` | 选题与素材筛选、优先级排序 |
| `douyin-video-production` | 生产计划：钩子、节奏、字幕、素材清单、质检 |
| `douyin-caption-cover` | 发布包：标题、文案、话题、封面文字与封面帧 |
| `douyin-publish-operator` | 创作者中心上传操作（最终发布由用户确认） |
| `douyin-fruit-commerce-strategy` | 抖音水果带货账号定位、内容支柱与转化路径 |

## 四、第三批 · 漫剧线 4 个

| 技能 | 真源 | 与真源关系 | 用途 |
|---|---|---|---|
| `mini-tiangong-drama` | `C:\Users\lsb\.workbuddy\skills\mini-tiangong-drama\` | 字节一致 | 小说蒸馏为上中下三集的原创可拍漫剧包 |
| `novel-to-tiangong-manju` | `C:\Users\lsb\.workbuddy\skills\novel-to-tiangong-manju\` | 字节一致 | 小说改编为天宫漫剧的改编链路 |
| `chinese-celestial-palace` | `C:\Users\lsb\.workbuddy\skills\chinese-celestial-palace\` | 已改写（本地版路由段不同） | 中式天宫视觉约束与静态生图提示词 |
| `sd2.5-tiangong-manju` | `E:\codex\niannianai\zhuanhuiyuangong\天宫漫剧_全流程交付包_20260826\B_Skills\sd2.5-tiangong-manju\` | 字节一致 | 天宫漫剧整部制作冠军（含 Seedance 2.5 图生视频） |

`chinese-celestial-palace` 的副本已按本项目需要改写路由段，**不是**真源快照；刷新前先确认哪一版是当前有效版本。

## 五、元数据规范

每个 `SKILL.md` 必须只有**一个** YAML frontmatter 块，且 `name`、`description` 各出现一次：

```yaml
---
name: <与所在目录同名>
description: <一句话用途与触发场景>
---
```

- `name` 必须与所在目录名一致，便于导入后定位。
- 出现重复 frontmatter 块时导入会失败或取到错误描述，验证脚本会阻断。

## 六、刷新规则

1. 真源更新后，整目录重新复制，不做逐行手改；
2. 复制后运行 `npm run verify`，确认元数据与索引仍一致；
3. 副本与真源出现差异时，在「与真源关系」列写明原因，不留无说明的漂移。

## 七、与 skills-archive 的关系

- 本目录是**在役可导入**技能；
- [skills-archive](../skills-archive/) 是**封存**技能（转绘线 7 个），只归档不导入，说明见 [00_归档说明.md](../skills-archive/转绘线/00_归档说明.md)。

## 红线

- 不把凭据、Token、Cookie、本地运行时状态写入技能副本；
- 不在技能副本里直接改上游真源；
- 技能副本不等于已授权执行：登录、发布、付费生成仍需用户当次明确授权。
