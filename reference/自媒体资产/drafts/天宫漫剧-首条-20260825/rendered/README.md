# rendered

> 本目录是**索引层**，不存放副本。真正的生产文件在权威主目录：`projects\天宫漫剧\rendered\`。
> 项目 ID：`tiangong-rebuild-v1` ｜ 账号：念念漫剧社 ｜ 规格：9:16 / 1080×1920

## 结构

```
rendered/
├── 上集/{assets,prompts}/
├── 中集/{assets,prompts}/
└── 下集/{assets,prompts}/
```

每个 `prompts/` 落 6 段提示词：`seg01_30s.md` … `seg06_30s.md`
每个 `assets/` 落四类参考图：`characters/`、`scenes/`、`props/`、`keyframes/`

## 编译规则（sd2.5-tiangong-manju）

- 唯一视频模式 = **Seedance 2.5 图生视频（I2V）**；不输出纯文生视频版
- 每个 `@图片` 必须声明「参考什么 / 不参考什么」，职责不得互相覆盖
- 上一段末帧 = 下一段首帧参考图
- 正文不写秒数 / 时间戳 / 帧号
- 交付门：候选片段通过连续性、动作、物理、声音、画面质量验收后才登记 `accepted_clip`

## 状态

🟢 **18 段 Seedance 提示词已全部落盘**（上集 / 中集 / 下集 各 6 段，见权威主目录 `projects\天宫漫剧\rendered\<集>\prompts\seg01_30s.md … seg06_30s.md`）。

| 集 | 提示词段数 | 每段体量 | assets 参考图 |
|---|---|---|---|
| 上集 | 6 / 6 | 5.1–7.0 KB | ⏳ 待资产拍板后回填 |
| 中集 | 6 / 6 | 6.9–8.8 KB | ⏳ 待资产拍板后回填 |
| 下集 | 6 / 6 | 9.4–14.1 KB | ⏳ 待资产拍板后回填 |

`assets\{characters,scenes,props,keyframes}` 四个子目录**已建好、当前为空**——等 M01–M10 验收拍板后，把验收图按角色 / 场景 / 道具 / 关键帧四类回填，即可进入 Seedance 2.5 成片生产。

> 注：提示词正文不含秒数 / 时间戳 / 帧号，段长由文件名 `segNN_30s` 表示。