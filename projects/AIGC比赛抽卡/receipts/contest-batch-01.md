# contest-batch-01 作业回执

- 授权：用户于 2026-09-26 明确授权本批次 15 张付费出图
- 首次提交：2026-09-26，15 张同时提交
- 桥地址：`http://127.0.0.1:8765`
- 模型：`midjourney` / `v8.2`
- 画幅：`16:9`
- 核对时间：2026-09-26

| 编号 | 作业号 | 当前状态 | 序列号 | 图片路径 |
|---|---|---|---|---|
| C01 | `contest-batch-01-C01_a26918cb4b` | done | `serial-2103525288418742272` | `E:\codex\multica\mj-automation\output\contest-batch-01-C01_a26918cb4b_blob.png` |
| C02 | `contest-batch-01-C02_faa602a759` | exception | 缺 | 缺 |
| C02 补交 | `contest-batch-01-C02-r2_faa602a759` | done | `serial-2103542227954307072` | `E:\codex\multica\mj-automation\output\contest-batch-01-C02-r2_faa602a759_blob.png` |
| C03 | `contest-batch-01-C03_5c4e8b63c3` | exception | 缺 | 缺 |
| C03 补交 | `contest-batch-01-C03-r2_5c4e8b63c3` | done | `serial-2103710012827242496` | `E:\codex\multica\mj-automation\output\contest-batch-01-C03-r2_5c4e8b63c3_2103710012827242496_hi.webp` |
| C04 补交 | `contest-batch-01-C04-r2_8a899ac656` | done | `serial-2103715119392362496` | `E:\codex\multica\mj-automation\output\contest-batch-01-C04-r2_8a899ac656_blob.png` |
| C04 | `contest-batch-01-C04_8a899ac656` | exception | 缺 | 缺 |
| C05 首次 | `contest-batch-01-C05_f4181869c5` | exception | 缺 | 缺 |
| C05 补交 | `contest-batch-01-C05-r2_f4181869c5` | queued，免费补下载成功 | `serial-2103720214439923712` | `E:\codex\multica\mj-automation\output\contest-batch-01-C05-r2_1.png` |
| C06 首次 | `contest-batch-01-C06_7402085d5d` | exception | 缺 | 缺 |
| C06 补交 | `contest-batch-01-C06-r2_7402085d5d` | queued；首次免费补下载失败 | `serial-2103726832829337600` | 缺 |
| C06 补下载 | `contest-batch-01-C06-r3` | done；免费补下载成功 | `serial-2103726832829337600` | `E:\codex\multica\mj-automation\output\contest-batch-01-C06-r3_2103726832829337600_hi.webp` |
| C07 | `contest-batch-01-C07_5cbcdc6e22` | exception | 缺 | 缺 |
| C08 | `contest-batch-01-C08_1e7c6a212f` | exception | 缺 | 缺 |
| C09 | `contest-batch-01-C09_460dbd57d9` | exception | 缺 | 缺 |
| C10 | `contest-batch-01-C10_40177525c3` | exception | 缺 | 缺 |
| C11 | `contest-batch-01-C11_88fd22558f` | exception | 缺 | 缺 |
| C12 | `contest-batch-01-C12_9f30953c53` | exception | 缺 | 缺 |
| C13 | `contest-batch-01-C13_9b3e6d5f49` | exception | 缺 | 缺 |
| C14 | `contest-batch-01-C14_08c51fa65d` | exception | 缺 | 缺 |
| C15 | `contest-batch-01-C15_2f0283ae32` | exception | 缺 | 缺 |

## 原因

C02 至 C15 的首次失败原因相同：等待浏览器锁超时 301 秒，当时浏览器由 C01 的进程占用。该失败发生在进入站内出图之前，没有返回序列号或图片。

C02 至 C04 已串行出图并通过高清校验，尺寸均为 2912×1632。C05 的作业等待 1200 秒后返回站内 `queued`，桥标记 `retryAllowed: false`；一次免费补下载成功，尺寸 2912×1632，没有重新生成。C06 等待 1200 秒后也返回 `queued`，序列号为 `serial-2103726832829337600`，首次免费补下载返回 `download_failed`：预览未打开、未取得合格图片。2026-09-26 改用 `POST /v1/maintenance` 的 `dl-serial` 模式，用同一序列号再次免费补下载并成功取回 2912×1632 的高清图（sha256 `15a118a29c`），未重新生成、未重复扣费。C07 至 C15 仍未提交，等待用户当次授权后按一次一张串行继续。积分实际扣减状态：缺（未核实）。

C06 补下载文件另存归档副本 `E:\codex\multica\mj-automation\archive\contest-batch-01-C06-r3.webp`。免费补下载不写入 `mj-automation/receipts/mxai-tasks.jsonl`，因此 C05 与 C06 的回收结果以本回执为准。

## 用户选择

4 选 1：缺。候选图尚未全部回收，不能写成已入选。
