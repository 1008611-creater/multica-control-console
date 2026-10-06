# receipts · 回执台账

这里放**每一次真实出图的记账**。一行一次，JSONL（每行一个 JSON 对象），只追加、不修改。

文件：`mxai-tasks.jsonl`

## 为什么要有它

改造前原项目的 `ai-rpa-console\.automation\receipts\mxai-tasks.jsonl` 是 **0 字节**，
而同期 `.automation\results\` 里躺着 27 个产物 —— 出了图却没有一条账，
既算不出成本，也复盘不了哪条提示词有效。

现在 `mxai_adapter.js` 在每次 `generate()` 结束（成功或失败）时都会追加一行，
由 `_writeReceipt()` 写入，落点由 `MJ_RECEIPTS_DIR` 控制，默认就是本目录。

## 字段定义

| 字段 | 类型 | 说明 |
|---|---|---|
| `ts` | string | 写入时刻，ISO 8601 |
| `task_id` | string\|null | 本次调用方给的任务号；HTTP 入口传的是 `mj_xxxxxxxx` |
| `prompt_hash` | string | 提示词 sha256 前 16 位。同提示词同参数可复现，靠它比对 |
| `requested_aspect` | string | 调用方要求的比例，如 `9:16` |
| `aspect` | string\|null | 页面上**实际选中**的档位，如 `1:2`。与上一条不一致说明档位没切成功 |
| `serial` | string\|null | 站内任务号，形如 `serial-2094365922813808640`。补下载靠它 |
| `files` | array | 通过校验、真正落盘的文件清单（见下） |
| `rejected` | array | 被内容校验拦下的文件及原因 |
| `status` | string | 见下表 |
| `seconds` | number | 从开始到结束的秒数 |
| `message` | string\|null | 人类可读的补充说明 |
| `started_at` | string | 开始时刻，ISO 8601 |

`files` 每一项：

| 字段 | 说明 |
|---|---|
| `file` | 绝对路径 |
| `bytes` | 字节数 |
| `w` / `h` | 像素宽高 |
| `format` | `png` / `jpeg` / `webp` |
| `sha256` | 内容哈希前 16 位，用于去重与复现比对 |

`rejected` 每一项：

| 字段 | 说明 |
|---|---|
| `file` | 绝对路径 |
| `verdict` | 判定码，见下表 |
| `reason` | 人话原因 |
| `bytes` / `w` / `h` | 实测值 |

## status 取值

| status | 含义 | 能否自动重试 |
|---|---|---|
| `ok` | 生成完成，且拿到了通过校验的高清原图 | — |
| `download_failed` | 生成完成，但没拿到合格图（可能已出图在站内） | **否**，先人工看站内 |
| `receipt_pending` | 已点「立即生成」但没拿到确定回执 | **否**，防止重复扣积分；不参与自动补下载 |
| `page_reported_failed` | 平台已判定本次生成失败（未出图），本次作业终态 | **可重提**，但会重新扣积分；须在本批授权内人工确认，并记录新作业号/序列号 |
| `need_login` | 登录态失效 | 否，需人工登录 |
| `timeout` | 等待超时 | 否 |
| `exception` | 流程抛异常 | 视情况 |
| `ASPECT_NOT_APPLIED` | 比例档位未切换成功，已中止，**未点击生成、未扣费** | 否，需先修档位选择 |
| `bad_request` | 参数不合法（如空提示词） | — |
| `adapter_missing` | 找不到适配器脚本 | — |

## verdict 判定码（内容校验）

| verdict | 含义 |
|---|---|
| `OK_HD` | 通过：格式合法、字节与尺寸都达下限 |
| `PLACEHOLDER_GIF` | GIF 占位图。MJ 不产出 GIF，实测 140077 字节的 loading 图就是这个 |
| `NOT_IMAGE` | 内容是 HTML/JSON，通常是错误页 |
| `BAD_FORMAT` | 不是受支持的图片格式 |
| `TOO_SMALL_BYTES` | 字节数低于下限 |
| `TOO_SMALL_DIM` | 尺寸低于下限 |
| `EMPTY` | 空文件 |
| `UNREADABLE` | 读不到文件 |
| `INSPECT_ERROR` | 校验过程本身出错 |

阈值由 `MJ_MIN_BYTES`（默认 200KB）和 `MJ_MIN_DIM`（默认 1024）控制。
参考量级：合格高清原图 5.6–9.3MB / 1792×2688；缩略图与占位图远低于 200KB。

## 怎么用

统计本次共出图几次、花了多少积分（每次约 6 积分）：

```powershell
Get-Content receipts\mxai-tasks.jsonl | ForEach-Object { $_ | ConvertFrom-Json } |
  Group-Object status | Select-Object Name, Count
```

也可以直接打服务的只读接口：`GET http://127.0.0.1:8765/v1/receipts?tail=50`

**注意**：`aspect` 与 `requested_aspect` 不一致就是**真问题**，不是"预期映射"。

2026-09-12 探针实测更正：中文版界面**有八档** ——
`1:1 / 1:2 / 16:9 / 9:16 / 4:3 / 3:4 / 3:2 / 2:3`（页面顺序），
所以 `9:16` 是**可以直选**的，不需要任何映射。
（旧文档说"只有四档、9:16 归到 1:2"是**错误结论**，已作废。）

因此：

- `aspect_ok: true` 且 `aspect_applied == aspect_requested` → 正常。
- `aspect_ok: false` → 页面档位没切成功。此时适配器**默认直接中止**（不点生成、不扣费），
  回执 `status` 为 `ASPECT_NOT_APPLIED`。只有显式传 `allowAspectDegrade: true` 才会继续。
- 历史遗留：`archive/` 与 `output/` 里那批 1536×3072（=0.5000，即 1:2）的图，
  全是旧版静默降级的产物，**不能当 9:16 资产用**。目标 9:16 的实际宽高比应为 0.5625。

真正要看的是 `files` 里的实际宽高比：9:16 应落在 0.5625 附近。
