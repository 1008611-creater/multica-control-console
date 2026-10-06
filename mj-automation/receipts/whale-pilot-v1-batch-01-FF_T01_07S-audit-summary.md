# FF_T01_07S 真实运行验收摘要

## 结论

单个真实任务已提交并被桥接收，但在平台侧以 `need_login` 结束。按停止规则，本轮验收阻断，不能判定出图成功，也不能判定扣费情况。

## 已验证

- `POST /v1/jobs` 返回 HTTP 202、任务编号和 `deduped: false`。
- 只提交了 1 个任务，任务总数由 0 变为 1。
- `GET /v1/jobs/{jobId}` 返回终态 `done`，业务结果为 `need_login`。
- 返回结构包含 `resultStatus`、`retryAllowed`、`submitted`、`billed`、`chargeKnown` 和 `actualPointDeduction`。
- `need_login` 被识别为停止状态，没有自动重试。
- 没有补下载、登录、重启或提交第二个任务。

## 未验证

- 未验证登录后的真实出图成功路径。
- 未验证真实扣费金额；本次 `chargeKnown=false`、`actualPointDeduction=null`。
- 未验证成功回执、图片文件和下载回收路径。
- 未验证批量并发和重试路径。

## 原始证据

- 任务回执：`E:\\Multica-Control-Console\\mj-automation\\run\\jobs\\whale-pilot-v1-batch-01-FF_T01_07S-audit_c4d1a360cd.json`
- 审计回执：`mj-automation/receipts/whale-pilot-v1-batch-01-FF_T01_07S-audit-receipt.json`
