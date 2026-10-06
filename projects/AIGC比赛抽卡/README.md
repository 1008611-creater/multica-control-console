# AIGC 比赛抽卡

项目 ID：`aigc-contest-draw-v1`

这里只记录比赛抽卡的批次、授权和验收，不搬动作品集原目录。

## 当前状态

- 状态：`in_progress`（单张失败不再触发停机）
- 抽卡桥：本机 `127.0.0.1:8765` 已接通
- 作品集：`E:\codex\aigc-motion-portfolio`，只读引用
- progress: batch 01 has paid authorization for 15 images; C01-C06 and C08-C15 have verified image files; C07 is a user-verified failed item with no output. C14-r9 serial `serial-2103944396905910272`, image `E:\codex\multica\mj-automation\output\contest-batch-01-C14-r9_08c51fa65d_2103944396905910272_hi.png`, 2912x1632. [User confirmed] any non-terminal batch with an executable or retryable item must keep three active job slots; terminal slots are refilled immediately; short slots use authorized failed-item retries; C07 is never retried.
- 批次状态映射：[batches/contest-batch-01.yaml](batches/contest-batch-01.yaml)
- 交付回执：[receipts/contest-batch-01.md](receipts/contest-batch-01.md)
- 无付费 dry-run 验收资产：[dry-run/README.md](dry-run/README.md)；验证脚本：`scripts/aigc-dry-run.ps1`。

## 下一步

1. User supplies the 4-of-1 selection;
2. Do not mark a candidate selected or publish before that choice;
3. New batches use strict three-concurrent execution: while a non-terminal batch has an executable or retryable item, keep three active jobs and fill short slots with authorized failed-item retries.

## 边界

- 不登录、不发布、不静默自动重跑；失败后按本批授权人工重提；
- 候选图必须经过用户 4 选 1；
- 缺失信息写「缺」，不估算比赛成绩或积分余额。
