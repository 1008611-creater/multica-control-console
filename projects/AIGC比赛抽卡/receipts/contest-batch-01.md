# contest-batch-01 作业回执

- 授权：用户于 2026-09-26 明确授权本批次 15 张付费出图
- 首次提交：2026-09-26，历史记录为 15 张同时提交
- 桥地址：`http://127.0.0.1:8765`
- 模型：`midjourney` / `v8.2`
- 画幅：`16:9`
- 核对时间：2026-09-26
- User rule: [User confirmed] a single failure does not stop the batch; while the batch is non-terminal and has an executable or retryable item, keep three concurrent job slots; immediately refill terminal slots; fill short slots with authorized failed-item retries; C07 remains the explicit no-retry exception.

| 编号 | 作业号 | 当前状态 | 序列号 | 图片路径 |
|---|---|---|---|---|
| C01 | `contest-batch-01-C01_a26918cb4b` | done | `serial-2103525288418742272` | `E:\codex\multica\mj-automation\output\contest-batch-01-C01_a26918cb4b_blob.png` |
| C02 | `contest-batch-01-C02-r2_faa602a759` | done | `serial-2103542227954307072` | `E:\codex\multica\mj-automation\output\contest-batch-01-C02-r2_faa602a759_blob.png` |
| C03 | `contest-batch-01-C03-r2_5c4e8b63c3` | done | `serial-2103710012827242496` | `E:\codex\multica\mj-automation\output\contest-batch-01-C03-r2_5c4e8b63c3_2103710012827242496_hi.webp` |
| C04 | `contest-batch-01-C04-r2_8a899ac656` | done | `serial-2103715119392362496` | `E:\codex\multica\mj-automation\output\contest-batch-01-C04-r2_8a899ac656_blob.png` |
| C05 | `contest-batch-01-C05-r2_f4181869c5` | done；免费补下载成功 | `serial-2103720214439923712` | `E:\codex\multica\mj-automation\output\contest-batch-01-C05-r2_1.png` |
| C06 | `contest-batch-01-C06-r3` | done；免费补下载成功 | `serial-2103726832829337600` | `E:\codex\multica\mj-automation\output\contest-batch-01-C06-r3_2103726832829337600_hi.webp` |
| C07 | `contest-batch-01-C07-r2_5cbcdc6e22` | page_reported_failed；用户已核实无成品；不重试 | `serial-2103846648898654208` | 缺 |
| C08 | `contest-batch-01-C08-r2_1e7c6a212f` | done；高清校验通过 | `serial-2103856976441118720` | `E:\codex\multica\mj-automation\output\contest-batch-01-C08-r2_1e7c6a212f_net.webp` |
| C09 | `contest-batch-01-C09-r3_460dbd57d9`（`retry_of`: `contest-batch-01-C09-r2_460dbd57d9`） | done；重提成功，高清校验通过；扣积分状态缺 | `serial-2103910138304794624` | `E:\codex\multica\mj-automation\output\contest-batch-01-C09-r3_460dbd57d9_2103910138304794624_hi.png` |
| C10 | `contest-batch-01-C10-r4_40177525c3`（`retry_of`: `contest-batch-01-C10-r3_40177525c3`） | done；重提成功，高清校验通过；扣积分状态缺 | `serial-2103922237408022528` | `E:\codex\multica\mj-automation\output\contest-batch-01-C10-r4_40177525c3_2103922237408022528_hi.png` |
| C11 | `contest-batch-01-C11-r3_88fd22558f` | done；高清校验通过 | `serial-2103915522050494464` | `E:\codex\multica\mj-automation\output\contest-batch-01-C11-r3_88fd22558f_2103915522050494464_hi.png` |
| C12 | `contest-batch-01-C12-r7_9f30953c53_9f30953c53`（`retry_of`: `contest-batch-01-C12-r6_9f30953c53`；r3-r6 失败回执均保留） | done；重提成功，高清校验通过；扣积分状态缺 | `serial-2103931954947690496` | `E:\codex\multica\mj-automation\output\contest-batch-01-C12-r7_9f30953c53_9f30953c53_2103931954947690496_hi.webp` |
| C13 | `contest-batch-01-C13-r4_9b3e6d5f49`（`retry_of`: `contest-batch-01-C13-r3_9b3e6d5f49`） | done；重提成功，高清校验通过；扣积分状态缺 | `serial-2103927025361227776` | `E:\codex\multica\mj-automation\output\contest-batch-01-C13-r4_9b3e6d5f49_2103927025361227776_hi.webp` |
| C14 | `contest-batch-01-C14-r9_08c51fa65d` (`retry_of`: `contest-batch-01-C14-r8_08c51fa65d`) | done; retry succeeded, HD validation passed; deduction unknown | `serial-2103944396905910272` | `E:\codex\multica\mj-automation\output\contest-batch-01-C14-r9_08c51fa65d_2103944396905910272_hi.png` |
| C15 | `contest-batch-01-C15-r6_2f0283ae32`（`retry_of`: `contest-batch-01-C15-r5_2f0283ae32`；r2 控制器取消、r3-r5 失败回执均保留） | done；独立高清图已回收，序列号缺，扣费状态缺 | 缺 | `E:\codex\multica\mj-automation\output\contest-batch-01-C15-r6_2f0283ae32_blob.png` |

## 当前执行证据

- No pending items remain; C12-r7, C14-r9 and C15-r6 have verified image files; the batch does not create an artificial third image after reaching terminal recovery.
- C10-r4, C12-r7, C13-r4, C14-r9 and C15-r6 have verified results; C14-r6/r7 remain excluded as duplicate old captures; C14-r8 remains a preserved browser-lock timeout receipt.
- 共享浏览器 profile 的锁可能让作业排队；这不改变批次层保持三个作业槽位的规则。
- C09 重提日志已返回 `done` / `ok: true`，序列号 `serial-2103910138304794624`，图片尺寸 2912×1632，文件已存在。
- C14-r9 serial and image path are now verified; C15-r6 has an independent image but serial remains unknown.

## 历史原因与处理

C02 至 C04 曾因浏览器锁超时后改为受控执行并成功回收；C05、C06 的成品通过同一序列号免费补下载取得，没有重新生成。C07 的桥回执为 `page_reported_failed`，用户已核实站内失败且无成品，实际扣积分数值缺，沿用此前不重试决定。

C09 原作业 `contest-batch-01-C09-r2_460dbd57d9` 返回 `page_reported_failed`，序列号 `serial-2103862230482161664`，无图片；按新规则保留原始回执后重提为 `contest-batch-01-C09-r3_460dbd57d9`，序列号 `serial-2103910138304794624`，已回收 2912×1632 高清图。重提扣积分状态缺。

C10 first attempt, C12 r3-r6, C13 r3, C14 r3-r5/r8 and C15 r3-r4 failed on browser-lock timeout; original receipts remain. C12-r7, C13-r4 and C14-r9 recovered successfully. C14-r6/r7 returned ok but had no serial and duplicated C12-r7 image SHA-256 53ff201c2c6888d8, so they are excluded. C15-r2 was stopped while waiting for the browser lock; platform submission and deduction remain unknown. Future active batches use strict three-concurrent execution while executable or retryable work exists; every retry preserves retry_of, new job, serial and deduction state; no silent infinite retry.

## 用户选择

4 选 1：缺。候选图尚未全部回收，不能写成已入选。


## 2026-09-26 verification update

- [Verified] C14-r9 returned `done` / `ok: true`.
- [Verified] Serial: `serial-2103944396905910272`; image: `E:\codex\multica\mj-automation\output\contest-batch-01-C14-r9_08c51fa65d_2103944396905910272_hi.png`; dimensions: 2912x1632; SHA-256 prefix: `01e758e347a116ae`.
- [User confirmed] Future active batches keep three active jobs whenever an executable or retryable item exists; short slots use authorized failed-item retries; no single-concurrency fallback.
- Current batch has no active jobs and awaits the user 4-of-1 selection.
