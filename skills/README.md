# 技能副本索引

本目录保存**可导入 Multica 的技能副本**，不是技能真源。副本可能来自外部技能库、仓库内编写或用户提供的附件；修改前按批次记录核对来源。

导入操作卡见 [05_阶段1_技能与智能体.md](../05_阶段1_技能与智能体.md)；技能名沿用原名，不得改名。

## 一、批次总览

| 批次 | 数量 | 技能 | 真源 | Multica 导入状态 |
|---|---|---|---|---|
| 第一批 · 核心 6 个 | 6 | 见下表 | `E:\codex\niannianai\zimeiti\skills\` | 已于 2026-09-25 导入 |
| 第二批 · 抖音线 6 个 | 6 | 见下表 | `C:\Users\lsb\.workbuddy\skills\` | 已于 2026-09-25 导入 |
| 第三批 · 漫剧线 4 个 | 4 | 见下表 | 混合，见下表 | 已于 2026-09-25 导入 |
| 第四批 · AIGC 比赛抽卡 1 个 | 1 | 见下表 | 本仓库新写，服务国内版 Midjourney 桥 | 已于 2026-09-25 导入 |
| 第五批 · 鲸歌计划资产抽卡 1 个 | 1 | 见下表 | 用户提供的技能附件；配套提示词规范一并保存 | 已于 2026-09-27 导入 |

前四批共 17 个技能的导入记录截至 2026-09-25；第五批 `mj-asset-card-drawer` 已于 2026-09-27 导入。导入回读 ID：`21e5734d-b3f1-42e9-8537-95cad9dc6f63`；技能正文及两份参考文件的 SHA-256 与本地副本一致。该技能仅进入技能库，未挂载到智能体。第四批 `mxai-contest-draw` 已挂到「内容生产」，原有四个技能保留。原有 `daily-sop-ops` 保留。

只读试跑 ANS-22 已于同日执行并通过 `npm run verify`，随后归档为完成。分派试跑 ANS-23 已由自媒体主控创建 ANS-24 并指派给内容生产；内容生产回报了 4 个已挂载技能。两条任务均已归档为完成，且没有重新启动。

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

第二批每个技能均带 3 个附属文件：`CONTRIBUTORS`、`agents/openai.yaml`、`references/` 下的参考文档。现场编号：

| 技能 | 编号 |
|---|---|
| `douyin-workflow-orchestrator` | `da200d9e-ad53-46b9-9f43-d288dd159d7d` |
| `douyin-video-selection` | `cf0ee074-9632-4d88-a2e2-5e25eb203546` |
| `douyin-video-production` | `20ab9915-ddf7-40e8-abcd-bd46e1a9cb89` |
| `douyin-caption-cover` | `3a767d84-dfd5-45ea-a7e6-98a55101e8d1` |
| `douyin-publish-operator` | `df82b217-5b11-4178-8ba6-bbf4e326cf97` |
| `douyin-fruit-commerce-strategy` | `7fb7e863-6592-4eca-a01d-feb35ad00fab` |

## 四、第三批 · 漫剧线 4 个

| 技能 | 真源 | 与真源关系 | 用途 |
|---|---|---|---|
| `mini-tiangong-drama` | `C:\Users\lsb\.workbuddy\skills\mini-tiangong-drama\` | 字节一致 | 小说蒸馏为上中下三集的原创可拍漫剧包 |
| `novel-to-tiangong-manju` | `C:\Users\lsb\.workbuddy\skills\novel-to-tiangong-manju\` | 字节一致 | 小说改编为天宫漫剧的改编链路 |
| `chinese-celestial-palace` | `C:\Users\lsb\.workbuddy\skills\chinese-celestial-palace\` | 已改写（本地版路由段不同） | 中式天宫视觉约束与静态生图提示词 |
| `sd2.5-tiangong-manju` | `E:\codex\niannianai\zhuanhuiyuangong\天宫漫剧_全流程交付包_20260826\B_Skills\sd2.5-tiangong-manju\` | 字节一致 | 天宫漫剧整部制作冠军（含 Seedance 2.5 图生视频） |

`chinese-celestial-palace` 的副本已按本项目需要改写路由段，**不是**真源快照；刷新前先确认哪一版是当前有效版本。

第三批附属文件已全部导入：`mini-tiangong-drama` 4 个、`chinese-celestial-palace` 4 个、`sd2.5-tiangong-manju` 3 个；`novel-to-tiangong-manju` 没有附属文件。现场编号：

| 技能 | 编号 |
|---|---|
| `mini-tiangong-drama` | `cfd3e2b5-393d-4940-92d2-7a6d380c25df` |
| `novel-to-tiangong-manju` | `4e455e32-c133-4418-b569-54aa676b9d91` |
| `chinese-celestial-palace` | `58d3dca7-cbf9-4439-9403-65f7533d0f57` |
| `sd2.5-tiangong-manju` | `44a7d763-68d8-4243-8eaa-5c6f88ff0907` |

## 五、第四批 · AIGC 比赛抽卡 1 个

真源：本仓库为国内版 Midjourney 抽卡新写，没有外部技能真源。

| 技能 | 用途 |
|---|---|
| `mxai-contest-draw` | 整理比赛提示词，调用本机 mxai 桥做免费自检；用户当次授权后保持三并发作业槽位抽卡并回收回执 |

现场编号：

| 技能 | 编号 |
|---|---|
| `mxai-contest-draw` | `fd348e23-93f6-4509-b4b1-123a9e9b6835` |

已于 2026-09-25 增量挂载到「内容生产」`d96f1b9f-a0b5-47ff-b51f-1f4b45c4dbe5`。该角色原有 `ai-trust-content`、`daihuo-product-video`、`manju-drama-studio`、`zhipian-behind-scenes` 均保留。
## 六、第五批 · 鲸歌计划资产抽卡 1 个

来源：用户提供的 `SKILL(2).md` 附件。随附的 `mj-prompt-spec(2).md` 是该技能的配套规范，不是单独技能；另附项目已有的资产映射副本以满足技能内引用。Multica 技能库已回读确认导入；尚未挂载到智能体。

| 技能 | 用途 | 配套文件 |
|---|---|---|
| `mj-asset-card-drawer` | 为鲸歌计划拆解可复用的 MJ 静态资产并编译抽卡提示词 | `references/mj-prompt-spec.md`、`references/whale-trailer-asset-map.md` |

## 七、元数据规范

每个 `SKILL.md` 必须只有**一个** YAML frontmatter 块，且 `name`、`description` 各出现一次：

```yaml
---
name: <与所在目录同名>
description: <一句话用途与触发场景>
---
```

- `name` 必须与所在目录名一致，便于导入后定位。
- 出现重复 frontmatter 块时导入会失败或取到错误描述，验证脚本会阻断。

## 八、刷新规则

1. 真源更新后，整目录重新复制，不做逐行手改；
2. 复制后运行 `npm run verify`，确认元数据与索引仍一致；
3. 副本与真源出现差异时，在「与真源关系」列写明原因，不留无说明的漂移。

## 九、与 skills-archive 的关系

- 本目录是**在役可导入**技能；
- [skills-archive](../skills-archive/) 是**封存**技能（转绘线 7 个），只归档不导入，说明见 [00_归档说明.md](../skills-archive/转绘线/00_归档说明.md)。

## 红线

- 不把凭据、Token、Cookie、本地运行时状态写入技能副本；
- 不在技能副本里直接改上游真源；
- 技能副本不等于已授权执行：登录、发布、付费生成仍需用户当次明确授权。
