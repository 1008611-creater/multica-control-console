# 项目控制台索引

本目录保存项目控制台、状态文件、索引，以及发布证据归档，不搬迁外部原始生产目录。

| 项目 ID | 控制台 | 状态真源 | 当前状态 |
|---|---|---|---|
| `tiangong-rebuild-v1` | `projects/天宫漫剧/` | `projects/天宫漫剧/project_state.yaml` | `in_production` |
| `aigc-contest-draw-v1` | `projects/AIGC比赛抽卡/` | `projects/AIGC比赛抽卡/project_state.yaml` | `in_progress` |
| `whale-pilot-v1` | `projects/whale-pilot/` | `projects/whale-pilot/project_state.yaml` | `blocked` |

## 非项目目录

下列目录不是项目控制台，没有 `project_state.yaml`，不参与项目身份判定：

| 目录 | 用途 |
|---|---|
| `projects/发布留档/` | 自媒体线的发布证据归档：作品页截图、链接记录与台账工作副本 |

## 项目识别规则

1. 先读取 `project_state.yaml` 的不可变 `project_id`；
2. 再读取项目 README 和相关资产索引；
3. 不使用线程标题、任务标题或目录显示名判断项目身份；
4. 新增项目必须复制状态契约字段，并在此表登记。

## 状态同步

项目状态变化时，同时更新：

- `project_state.yaml`：机器可读的唯一状态；
- 项目 `README.md`：人类可读的原因、阻塞和下一步；
- 相关任务评论或交付记录：本次变更的证据。



