# 项目状态契约

`projects/*/project_state.yaml` 是项目身份和生命周期的唯一真源。任务标题、线程标题、目录名和聊天上下文都不能替代 `project_id`。

## 必填字段

| 字段 | 类型 | 规则 |
|---|---|---|
| `project_id` | string | 不可变，字母/数字/`.`/`_`/`-` |
| `project_name` | string | 面向用户的项目名 |
| `status` | enum | `idea`、`specified`、`planned`、`in_production`、`in_progress`、`awaiting_review`、`accepted`、`shipped`、`measured`、`blocked` |
| `source_of_truth` | path | 必须指向当前状态文件 |
| `deliverables` | list | 每项含 `id`、`status`、`path` |
| `blockers` | list | 没有阻塞时使用 `[]`，不得删除字段 |
| `authorization` | map | 至少声明付费生成和平台发布的授权策略 |
| `paths` | map | 控制台、原始生产目录和 Multica 工作目录 |
| `red_lines` | list | 项目不可放宽的安全与合规边界 |

## 状态转移

```text
idea → specified → planned → in_progress → awaiting_review
                                      ├→ accepted → shipped → measured
                                      └→ blocked → planned
```

状态转移必须由任务产物和验收证据驱动。没有用户发布回执时，不得从 `accepted` 直接写成 `shipped`。

## 更新规则

1. 先修改状态文件，再在对应项目 README 记录原因和下一步。
2. `project_id` 一旦创建不得复用或改名。
3. 交付物状态只能引用真实文件、索引或用户回执。
4. 付费生成按批次授权；平台发布按动作授权；最终审美确认归用户。
5. 阻塞状态必须有原因、影响范围和解除条件；无阻塞仍保留 `blockers: []`。
