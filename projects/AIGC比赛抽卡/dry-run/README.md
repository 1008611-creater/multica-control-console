# 无付费 dry-run 验收资产

## 用途

这套资产把 AIGC 抽卡的一页式验收清单落成一个**离线、无付费、无桥访问**的可重复验证。它只验证输入读取、串行状态、失败重提、不重试、阻塞、回执字段和 worktree 回传物的规则。

它不会启动 Multica，不会访问 `127.0.0.1:8765`，不会生成图片，也不会调用付费接口。

## 文件

- `fixture.json`：四种状态场景的静态模拟输入；
- `../../../scripts/aigc-dry-run.ps1`：离线验证脚本；
- `dry-run-report.md`：验收结果；
- `dry-run-receipt.md`：模拟回执；
- `dry-run-state-map.json`：模拟状态映射；
- `handoff-manifest.md`：worktree 回传物清单。

最后四个文件由脚本写入指定的隔离输出目录，不应被当作真实生产回执。

## 执行方式

从仓库根目录运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/aigc-dry-run.ps1 `
  -FixtureFile projects/AIGC比赛抽卡/dry-run/fixture.json `
  -OutputDir tmp/aigc-dry-run
```

随后运行仓库验证：

```powershell
npm run verify
```

## 通过标准

- 输入包可读，未知字段写「缺」；
- 网络请求、付费调用和图片生成均为 0；
- 成功、失败重提、禁止重提和扣费未知阻塞四种场景均通过；
- 原始失败和 `retry_of` 关系保留；
- 输出只写入隔离目录，主工作区写入次数为 0；
- 报告明确写出真实桥、真实图片和真实扣费状态仍未验证；
- `npm run verify` 通过。

## 边界

通过这项 dry-run 只说明本地规则和回传格式可验证，不代表 Multica 或抽卡桥的生产链路已通过。
