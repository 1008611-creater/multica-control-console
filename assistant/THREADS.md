# 线程登记（2026-09-28）

| 线程 | 状态 | 产物 | 证据 | 未验证 |
|---|---|---|---|---|
| 当前主线程（2026-09-28 源码发布） | 源码已推送；旧版清理被主机策略拦截 | 私有仓库 1008611-creater/multica-control-console，commit 773646a | GitHub main 回读；42 文件；验收、Node/Python 测试与桌面源码编译通过 | dist 中旧版本仍在；跨电脑和真实平台仍未验证 |
| 当前主线程 | 已完成本轮实现，等待真实用户验收 | `mj-automation/control/index.html` 真实批次工作台 | `node --check`、`npm run verify`、`npm test`、Playwright 页面检查、三并发拦截式检查 | 真实登录、真实付费提交、真实成品回收、安装包重建 |

本轮纠正：旧的离线样例不再作为产品入口，只保留在备份文件中供追溯。页面和桥服务源码已同步到本机安装目录并保留旧版备份；分发安装包尚未重建。已启动本机安装目录控制台并回读 8765；真实平台操作均未执行。

# 线程登记

## 更新日期：2026-09-27

## 当前议题

| 线程 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | 文档与边界收敛已完成；仓库复核通过 | 让仓库、中文工作台、运行数据和 Windows 分发件职责一致 | 核心文档已统一；`/runtime/`、`/dist/` 已忽略但未移动；`npm run verify`、12 项 Node 与 3 项 Python 测试通过 | 单批次三并发队列尚未在页面呈现；隔离安装升级和分发包凭据内容仍待验证；不重建同名分发件 |

以下条目是按发生时间保留的历史记录，不自动代表当前状态；当前状态以 `assistant/CURRENT.md` 和项目状态真源为准。

本轮离线批次队列（2026-09-27）

| 线程 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | 离线批次队列已实现，真实批次接入未完成 | 让用户看懂 6 个样例任务、三并发槽位、失败原因和重提条件 | 页面含独立离线样例区；初始 `3 / 3`；推进与安全重提均为内存模拟；不调用 `/v1/jobs` | 真实桥批次 manifest/attempts、平台登录、付费生成和成品回收仍保持未验证 |

## [待核验] 历史损坏线程记录（原始正文保留）

Updated: 2026-09-27
| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| 当前 Codex 主线程 | 离线批次队列已实现，真实批次接入未完成 | 让仓库、中文工作台和 Windows 分发件职责一致 | 核心文档、离线样例队列、三并发状态与验收条款已同步；`npm run verify`、`npm test`通过 | 真实批次 manifest/attempts、隔离安装升级和分发包凭据内容仍待验证 |
| Multica Issue ANS-33 | blocked (historical connectivity probe) | Complete local Multica connectivity probe | Same-machine GET /health succeeded; historical path-write permission issue remains separate from this batch | Do not change historical Issue |

## ??

- [???] ?????projects/whale-pilot/asset-index.md
- [???] batch-02-retry-01 summary?mj-automation/receipts/whale-pilot-v1-batch-02-retry-01-summary.json
- [???] batch-01-retry-04 summary?mj-automation/receipts/whale-pilot-v1-batch-01-retry-04-summary.json
- [???] ?????????? npm run verify ????
- [???] ???????????????

## [待核验] 开头历史线程记录损坏说明

- [已验证] 本文件开头的旧主线程行和其后的损坏说明含实际问号字符，并非显示问题。
- [待核验] 旧线程目标、数量、历史验收与下一步说明无法可靠还原；原始内容保留作损坏证据，不猜写。当前项目状态以 `projects/whale-pilot/project_state.yaml` 为准。
- [已验证] 引用文件存在：`projects/whale-pilot/asset-index.md`、`mj-automation/receipts/whale-pilot-v1-batch-02-retry-01-summary.json`、`mj-automation/receipts/whale-pilot-v1-batch-01-retry-04-summary.json`。
- [已验证] 本轮 `npm run verify` 通过，`npm test` 通过（12 项 Node、3 项 Python）；不据此回填旧线程行的历史结果。

## AIGC dry-run implementation

| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| Current Codex main thread | dry-run asset landed | Implement offline no-fee acceptance plan | Script and fixture pass in isolated temp output; no Multica, bridge, image, or paid call | Repository verification and post-coding review passed |

## Local browser control console (2026-09-27)

| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| Current Codex main thread | control_console_available_login_blocked | Give the user a visual way to stop/restart browser control and complete manual login | Control page and browser-control script verified; watchdog paused; bridge health and control state read back successfully | User opens the control page, starts the visible login browser, and logs in manually |

## MJ bridge retry gate (2026-09-27)

| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| Current Codex main thread | retry_gate_repo_verified_manual_review_complete | Prevent unsafe automatic MJ job resubmission and add regression tests | 12 Node and 3 Python tests plus `npm run verify` pass; real bridge was not contacted; end-to-end retry path manually reviewed | Runtime deployment remains unverified and requires a separate authorized restart; do not run generation, retry, download, or login in this task |



## Local draw bridge workbench (2026-09-27)

| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| Current Codex main thread | workbench_implemented_no_paid_generation | Let the user operate the draw bridge from a local visual console | Workbench, root redirect, health, control state, rendered page, paid gate, free lint, and repository verification passed | User can open `/control`; real generation remains an explicit user action |

## Portable package (2026-09-27)

| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| Current Codex main thread | package_verified_pending_external_machine | Package the Multica visual control console for distribution | Portable directory and ZIP created; setup/start/control/state/stop smoke test passed; no browser profile or credentials bundled | Send ZIP to a test machine and run `Setup-Multica.cmd`, then `Start-Multica.cmd` |- [已验证] Manual post-coding review checked the changed portable scripts, package manifest, credential/profile exclusion, start/stop path, control route, and final ZIP contents.
- [待核验] No second-machine install or real platform generation was performed in this review.

## 面向非技术用户的回复规范优化（2026-09-27）

| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| Current Codex main thread | global_reply_guidance_moved_verified | 把面向新手的通用回复、逐步操作指导和真实服务核验边界放到全局规则 | `C:\Users\lsb\.codex\AGENTS.md` 已加入白话表达、术语解释、逐步指导，并要求区分样例检查与真实服务核对；`npm run verify` 通过，全局文件已人工回读 | 后续按用户反馈继续微调全局规则 |
## Local draw bridge workbench post-fix verification (2026-09-27)

| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| Current Codex main thread | workbench_verified_no_paid_generation | Let the user operate the draw bridge from a local visual console | UTF-8 page, route readback, free lint, repository checks, and headless paid-gate smoke passed; no paid POST was made | User may open http://127.0.0.1:8765/control; actual generation remains an explicit user action |

## Local installation and installer improvement (2026-09-27)

| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| Current Codex main thread | installed_and_running_external_acceptance_pending | Install the console on this machine and improve distribution flow | `E:\Multica-Control-Console` is running; `/health` and `/control` verified; desktop shortcut exists; watchdog paused | User can open the control page and complete manual login when ready |
## Local draw bridge product UI refresh (2026-09-27)

| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| Current Codex main thread | product_ui_refreshed_no_paid_generation | Make the bridge feel like a complete local product website | Navigation rail, visual hierarchy, responsive layout, Chinese interface copy, preserved safety gate, and desktop/mobile smoke checks passed | User reviews the refreshed page and gives visual feedback; real generation remains explicit |

## MJ bridge runtime read-only audit (2026-09-27)

## MJ bridge single real runtime acceptance (2026-09-27)

| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| Current Codex main thread | single_real_runtime_acceptance_blocked_need_login | 使用正式素材 `FF_T01_07S` 做一次真实运行验收 | 仅提交 1 次，HTTP 202 返回 job ID；终态为 `done / need_login`，无图片，`chargeKnown=false`，未自动重试、未补下载、未登录、未重启；回执已保存 | 等待用户决定是否亲自完成平台登录；登录后仍需单独授权并重新验证成功回执和扣费字段 |

| Thread / Issue | Status | Goal | Verified result | Next |
|---|---|---|---|---|
| Current Codex main thread | runtime_code_matches_live_idle | 核对运行中的抽卡桥是否加载了重试闸门代码 | `/health`、`/control/state`、`/v1/jobs` 均可读；桥标记为 `2026-09-27-workbench-01`，任务数为 0；安装目录与工作区 `production_machine.mjs` SHA-256 一致；未触发任何付费动作 | 若要核对真实任务状态，需要用户先有一个已存在的任务或明确授权一次真实提交；当前无需继续操作 |

## Multica 本地控制台界面与分发包更新（2026-09-27）

| 线程 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | 界面更新已安装并通过本机验收；待跨机器安装验证 | 提升工作台字体、间距、动效、中文状态反馈并同步安装版与分发包 | 三份页面哈希一致；三种窗口宽度无横向溢出；安装版服务/API/免费 lint/停止链路通过；付费闸门、离线禁用、包内敏感路径核验通过；`npm run verify` 与 12+3 项测试通过 | 跨机器首次安装、批次 manifest/attempts 三并发只读视图；不登录、不付费生成 |

- [已验证] 最新分发包：`dist/Multica-Control-Console-2026-09-27.zip`。
- [待验证] 真实登录、付费出图、图片回收和另一台 Windows 设备安装。
## 单文件 Windows 安装器（2026-09-27）

| 线程 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | 单文件安装器已生成；待桌面目视与跨设备验收 | 将本地控制台打包为可安装的 Windows EXE，并验证升级保留用户数据 | 4.05 MB EXE；临时首次安装和升级通过；档案/任务/回执/输出/归档/本地配置哨兵哈希未变；临时服务 API 启动、读取、停止通过；12+3 项测试和 `npm run verify` 通过 | 用户可在本机双击检查安装窗口；签名证书与另一台 Windows 首次安装仍待确认 |

- [已验证] 安装器：`dist/Multica-Control-Console-Setup-2026-09-27.exe`；SHA-256：`657D25B2F4408C81B88BE7B397555D15AB04772B15734AB2CA9528AD2187D202`。
- [已验证] 本轮无平台登录、无生成提交、无付费接口调用；现有 `http://127.0.0.1:8765` 服务仍运行，状态未被改动。
- [待验证] 安装器未签名，普通安装窗口未人工目视检查，跨设备安装未执行；Python/Node.js 运行环境仍需预先安装。


## 单文件 Windows 安装器最终验收（2026-09-27）

| 线程 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | bundled_runtime_installer_verified | 生成并验收带内置运行时的单文件 Windows 安装器 | 全新临时安装、内置 Python 启动、`/health`/`/control`/`/control/state`、停止、升级数据保留均通过；修复内置 Python 停止识别；`npm run verify`、12 个 Node 测试、3 个内置 Python 测试通过 | 用户可双击检查安装窗口；跨设备安装、代码签名和真实平台操作仍待验证 |

- [已验证] 安装器：`dist/Multica-Control-Console-Setup-2026-09-27.exe`。
- [已验证] 安装器 SHA-256：`DA022799732830BAC9E6C8EC6458BD671E5AB82C9DF4D1CB4F7F4F8D9EF962E4`。
- [已验证] 分发 ZIP SHA-256：`305482D754F9720F638B4A4D7AE914C04F811999B3FD06C82A65A58597218160`。
- [已验证] 安装器已内置 Python 3.11、Node.js 和 Playwright；不要求目标机预装 Python/Node；Microsoft Edge 仍需目标机已有。
- [已验证] 无登录、无出图、无付费调用；正式 8765 服务保持运行。
- [待验证] 另一台 Windows 首次安装、安装窗口人工目视检查、代码签名。

## Multica 产品愿景基线（2026-09-27）

| 线程 / 议题 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | 产品定义稿已落地，待用户确认 | 先确定理想状态，再继续专业化改造 | `docs/multica-workbench-product-vision.md` 已创建；控制台源码和 `/control` 返回确认是 UTF-8 正常中文；本轮未触发外部平台动作 | 用户确认后，按规格重做信息架构和页面；优先离线样例队列与三并发状态展示 |

## 单文件安装器最终可验收版本（2026-09-27）

| 线程 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | ready_for_user_acceptance | 交付可直接验收的单文件 Windows 控制台 | 安装器已修复升级路径和内置 Python 选择；全新安装、旧版升级、数据保留、正式服务启动/停止和控制台接口均通过 | 用户打开控制台页面和 EXE 做人工验收 |

- [已验证] EXE：`dist\Multica-Control-Console-Setup-2026-09-27.exe`。
- [已验证] EXE SHA-256：`B11C1549A6B246D479DE661C079FB39C2BD416006C17CBAEC1E01BE2FEBA4C03`。
- [已验证] ZIP SHA-256：`CDCEA3D7422AC5457B03C669655DA45031A707A3F5DFEF18DB551D33F3C9C439`。
- [已验证] 正式控制台：`http://127.0.0.1:8765/control`，HTTP 200，服务正常，浏览器未启动，自动看护已暂停。
- [已验证] 安装目录源码页面与脚本已和仓库权威源码一致；不存在旧升级生成的重复目录。
- [已验证] 无登录、无出图、无付费接口调用；安装包不含浏览器档案、凭据、生成媒体或本地配置。
- [待验证] 用户人工目视验收、跨设备安装、代码签名和真实平台操作。
## 单文件安装器与正式控制台最终验收补充（2026-09-27）

| 线程 / 议题 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | ready_for_user_visual_acceptance | 完成单文件安装器和正式控制台的本机最终验收 | Playwright `multica-accept` 已检查正式页面标题、三种窗口尺寸、付费闸门、刷新无错误；正式 `/health`、`/control`、`/control/state` 均为 200，当前 0 作业、0 回执，未产生付费/登录/生成请求 | 用户打开页面和 EXE 做人工目视确认；跨设备安装、签名和真实平台操作仍待验证 |

- [已验证] 正式入口：`http://127.0.0.1:8765/control`。
- [已验证] 最新 EXE：`dist\Multica-Control-Console-Setup-2026-09-27.exe`；SHA-256：`B11C1549A6B246D479DE661C079FB39C2BD416006C17CBAEC1E01BE2FEBA4C03`。
- [已验证] 最新 ZIP：`dist\Multica-Control-Console-2026-09-27.zip`；SHA-256：`CDCEA3D7422AC5457B03C669655DA45031A707A3F5DFEF18DB551D33F3C9C439`。
- [未验证] 用户人工目视、另一台 Windows 安装、代码签名、真实登录和付费生成。

## 文档索引与项目状态漂移修复

| 线程 / 议题 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | 历史记录（已由下行结果覆盖） | 对齐 ADR/产品文档索引与项目状态索引，并增加漂移检查 | 当时等待验证；最终结果见下行 | — |

| 当前 Codex 主线程 | 已验证 | 对齐 ADR/产品文档索引与项目状态索引，并增加漂移检查 | `npm run verify` 通过；`npm test` 通过（12 项 Node、3 项 Python）；7 个 ADR 均已索引，三个项目的索引状态与权威状态文件一致 | README 技能数量已修正；历史损坏仅恢复可核实内容，其余明确标记待核验 |

## 单文件安装器与正式控制台最终验收补充（2026-09-27）

| 线程 / 议题 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | ready_for_user_visual_acceptance | 完成单文件安装器和正式控制台的本机最终验收 | Playwright `multica-accept` 已检查正式页面标题、三种窗口尺寸、付费闸门、刷新无错误；正式 `/health`、`/control`、`/control/state` 均为 200，当前 0 作业、0 回执，未产生付费/登录/生成请求 | 用户打开页面和 EXE 做人工目视确认；跨设备安装、签名和真实平台操作仍待验证 |

- [已验证] 正式入口：`http://127.0.0.1:8765/control`。
- [已验证] 最新 EXE：`dist\Multica-Control-Console-Setup-2026-09-27.exe`；SHA-256：`B11C1549A6B246D479DE661C079FB39C2BD416006C17CBAEC1E01BE2FEBA4C03`。
- [已验证] 最新 ZIP：`dist\Multica-Control-Console-2026-09-27.zip`；SHA-256：`CDCEA3D7422AC5457B03C669655DA45031A707A3F5DFEF18DB551D33F3C9C439`。
- [未验证] 用户人工目视、另一台 Windows 安装、代码签名、真实登录和付费生成。

## Multica 文件夹审计（2026-09-27）

| 线程 / 议题 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | 追加审计事项已验证 | 更新技能计数、审计分发/运行/浏览器证据目录、标注不可恢复的历史损坏 | `README.md` 已对齐为 17 个技能；`docs/multica-folder-audit.md` 记录目录体积/用途/Git 状态且未改目录；问号段落已标记待核验；`npm run verify` 和 `npm test` 通过（12 项 Node、3 项 Python） | 跨设备安装及真实平台使用仍未验证；本次未登录或付费生成 |

- [事后审查] 已读取并按 `E:\codex\aisp\aidaihuo-handoff-control\skills\post-coding-review\SKILL.md` 复核审计交付及其使用边界；界面/安装链路未因本轮文档审计而重新验证。

## 鲸歌计划 P0 人物与场景拆解（2026-09-27）

| 线程 / 议题 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线 | P0 需求拆解已完；等待目视验收 | 依据权威分镜建立人物与场景资产需求 | 12 项 P0 资产映射到 S01–S12；已目视抽查候选，排除 2 张标错或无效的兰伯特图，保留 4 张待验收候选；本轮未出图、未提交付费任务 | 用户目视审核现有候选图；收到验收后再进入提示词编制或新图申请 |

- [已验证] 权威分镜副本位于 `C:\Users\lsb\Pictures\1aigc\鲸鱼\先导片\剧本\权威分镜\鲸鱼 先导片分镜头_权威副本.docx`；哈希与原件一致。
- [事后审查] 本轮依 `post-coding-review` 技能检查实际改动、镜头到资产映射、候选图依赖和文件存在性；`npm run verify` 通过；12 项资产/12 镜头清单解析正常，6 张候选图均存在，已按 `post-coding-review` 复核端到端的验收门槛。

## 正式控制台中文页面上线核对（2026-09-27）

| 线程 / 议题 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | chinese_ui_live_cache_fixed | 核对控制台是否仍为旧英文版并修复缓存导致的旧页面显示 | 权威源码、安装目录、分发目录均为中文；正式 `/control` 返回中文标题和正文；已加入禁止缓存响应头并重启 8765；最新 EXE/ZIP 已重建 | 用户对当前标签执行一次 `Ctrl+F5`，确认页面显示中文 |

- [已验证] 最新安装器 SHA-256：`8242D2EC72FD2EF55A37C6B8421F7D270FD050F842DFF1BB671276E0E3400E61`。
- [已验证] 正式服务仍运行在 `127.0.0.1:8765`；无登录、无出图、无付费请求。
- [待用户操作] 刷新当前旧标签；如仍显示英文，打开 `http://127.0.0.1:8765/control?lang=zh-CN&v=20260927`。


## 当前主线程：产品与分发边界收敛（2026-09-27）

| 线程 / 议题 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | 文档与版本边界已收敛；安装升级待实测 | 统一本地抽卡工作台定位并划清源码、依赖、用户数据、回执和分发物边界 | README、PROJECT_CONTEXT、产品规格/愿景、架构、ADR、验收、索引与 `.gitignore` 已更新；`npm run verify`、`npm test` 通过 | 需在临时隔离目录做安装/升级保留检查并核对分发包；真实平台操作不在本轮 |

- [已验证] 本轮没有删除、移动或重建 `runtime/`、`dist/`、`installers/`、`.playwright-cli/` 或 `mj-automation/` 内容。
- [待验证] 安装包跨机器启动与升级数据保留；当前文档条款只是验收条件，不代表已经通过。

## 手动登录浏览器反复刷新修复（2026-09-27）

| 线程 / 议题 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | manual_login_browser_stable | 修复打开登录浏览器后页面反复刷新、无法登录的问题 | 手动登录模式已与生成导航流程分离；旧 PID 识别已修复；正式实例重新启动后状态为 `not_logged_in`，日志确认不会自动重载或关闭登录弹窗 | 用户在已打开的浏览器窗口中手动登录；登录完成后回到控制台查看状态 |

- [已验证] 正式服务仍运行在 `127.0.0.1:8765`。
- [已验证] 最新 EXE SHA-256：`0479E03BCDDF503F2ECA9E6E3A99464CBBCA264A31713A317272F29FC6F43DDA`。
- [已验证] 本轮没有提交任务、出图或付费调用。
- [待用户操作] 手动完成平台登录；登录是用户本人操作，助手不代填凭据。

## 第五批技能导入（2026-09-27）

| 线程 / 议题 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | 已导入技能库，未挂载智能体 | 将 `mj-asset-card-drawer` 与配套规范导入 Multica | CLI 回读唯一技能 ID `21e5734d-b3f1-42e9-8537-95cad9dc6f63`；正文和两份参考文件哈希与本地副本一致；技能库数量 18 → 19 | 如需在智能体中直接调用，再明确指定智能体；挂载前核实重复项及影响 |

## 安装窗口可读性改进（2026-09-27）

| 线程 / 议题 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | installer_dialog_simplified | 修复安装时出现难懂系统文件夹窗口的问题 | 自动识别常见旧安装位置；首次安装/更新显示中文向导；新 EXE 临时首次安装、升级及任务文件保留检查通过；`npm run verify` 通过 | 用户可打开新版 EXE 检查实际窗口；跨设备安装和代码签名未验证 |

- [已验证] 原因：旧版每次强制用户在系统目录树中选择安装位置，没有自动识别现有安装。
- [已验证] 新安装器：`dist/Multica-Control-Console-Setup-2026-09-27-ux.exe`；SHA-256：`E4C8D1390AD0CC2C5F7AA4A2AD28CD8B01127B04B1CAD40E3FDAEA112F542814`。
- [已验证] 配套分发 ZIP：`dist/Multica-Control-Console-2026-09-27-ux.zip`；正式安装目录与 `127.0.0.1:8765` 服务未改动。
- [待验证] 新窗口的人工目视验收、另一台 Windows 的安装、代码签名。

## 安装器最终版本补充（2026-09-28）

- [已验证] 当前可交付 EXE：`dist/Multica-Control-Console-Setup-2026-09-28-ux.exe`；SHA-256：`0B2228C1651E65AFD83B758B38C513DCC5D212DED5488135F61FE82716E4F812`。
- [已验证] 配套 ZIP：`dist/Multica-Control-Console-2026-09-28-ux.zip`；用该 EXE 做临时目录升级通过，任务哨兵哈希未变。
- [待用户验收] 新安装窗口尚未在真实桌面上目视检查；正式安装目录和运行服务未改动。

## 主线｜离线批次尝试记录与回执详情（2026-09-27）

- 一句话结论：已把离线三并发样例从“只有总表”补成“总表 + 单项尝试/回执详情”。
- 对总任务影响：用户可以逐项核对模拟状态、尝试次数、失败原因、扣费状态、重提条件和成品位置；不改变真实桥职责。
- 需要决定：无需用户决定；本轮保持离线样例边界。
- 技术证据：`mj-automation/control/index.html` 新增详情面板、尝试时间线和模拟回执字段；`docs/acceptance.md` 新增对应验收条款。
- 尚未验证：真实批次文件只读接入、真实平台回执、真实成品路径、安装包重新构建。


## 安装器交付基准更正（2026-09-27）

- [已失效] 较早 27-ux 构建哈希 `E4C8...` 与 28-ux 构建不作为当前交付版本。
- [已验证] 当前交付 EXE：`dist/Multica-Control-Console-Setup-2026-09-27-ux.exe`，SHA-256：`A209C5AEA9C9A118CC94B307E81B2E7FD03E12CE104D1BE8B270F182AD86722E`；配套 ZIP：`dist/Multica-Control-Console-2026-09-27-ux.zip`。
- [已验证] 最终 EXE 隔离首次安装和升级通过；任务哨兵未变；`npm run verify` 通过。
- [待用户验收] 新安装窗口的桌面目视与正式目录升级仍待用户决定。
- [???] ????????????????/??????????????????????????
- [???] ????????????????`npm run verify`?`npm test` ???

## 桌面产品 EXE 化（2026-09-28）

| 线程 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 当前 Codex 主线程 | product_exe_built | 把本地抽卡工作台做成可分发的成熟 Windows 桌面产品 | 新增自包含 `Multica.exe`；启动后显示本地服务、浏览器和队列状态；可打开中文工作台、登录浏览器、成品目录和安装目录；ZIP 与安装器均已生成；`npm run verify`、`npm test` 通过 | 用户可双击 `dist/Multica-Control-Console-Setup-2026-09-28-product.exe` 做本机目视验收；跨设备、签名和真实平台操作仍待验证 |

- [已验证] 桌面 EXE：`dist/Multica-Control-Console-2026-09-28-product/Multica.exe`，约 49.2 MB。
- [已验证] 分发 ZIP：`dist/Multica-Control-Console-2026-09-28-product.zip`，约 114 MB。
- [已验证] 安装器：`dist/Multica-Control-Console-Setup-2026-09-28-product.exe`，约 112 MB；SHA-256：`4977E9574D07F78DB627C1290D7B6151F4712F482A37B4FBE2CD57C18F159FB4`。
- [已验证] 本轮未登录、未提交、未付费、未下载、未对外发送。
- [待核验] 另一台 Windows 首次安装、代码签名、人工视觉验收和真实平台回执。
- [已验证] 新版桌面程序已写入本机正式安装目录 `E:\Multica-Control-Console\Multica.exe`；本机用户数据哨兵（任务、回执、输出、归档、配置、浏览器档案）更新前后未变化。


## Global response-format plugin enabled (2026-09-28)

| Thread | Status | Artifact | Evidence | Not verified |
|---|---|---|---|---|
| Current main thread | Plugin enabled | Codex plugin `i-have-adhd@i-have-adhd`, version `0.3.0` | `codex plugin list` shows `installed, enabled`; cached `SKILL.md` SHA-256 matches the GitHub clone | Skill-menu discovery after restarting for a new session |


## G1-R5 MJ ?????2026-09-28?

| ?? | ?? | ?? | ?? | ??? |
|---|---|---|---|---|
| ????? | ?????? | ??? Multica ?? Edge ???? | `/health` HTTP 200?`/control/browser/start` ?? `started`?`/control/state` ????? `running=true`?`loggedIn=false` | ?????01?04 ????????????????? |


## G1-R5 MJ ?????2026-09-28?

| ?? | ?? | ?? | ?? | ??? |
|---|---|---|---|---|
| ????? | ???????? | G1-R5-01 ? G1-R5-04 ?? Multica ???? | ?? POST `/v1/jobs` ? HTTP 202?`deduped=false`?GET `/v1/jobs` ???? `running` | ????????????????????? |

## G1-R6 MJ 批次回执与图片验收更正（2026-09-28）
- [已验证] 用户自建国内 MJ 自动化经 Multica 本机桥和 Playwright 适配器操作 MXAI 生图页，模型为 Midjourney v8.2；四份日志均有点击生成、完成序列号和高清图校验，状态为 `done/ok`，自动化已提交并完成。四张图均为 2×2 拼贴，验收不通过。
- [用户确认] 用户查看时官方 MJ 网站队列为空；该页面与本批 MXAI 自动化任务无关，不能据此否定本批执行结果。
- [已验证] R6 和 R5-01 重试实际费用均未知。R5-01 是独立 MXAI 自动化结果，不属于 R6；更早 R5 四项因浏览器锁等待超时失败。
- 详细路径、SHA-256、尺寸、回执及事后审查见 `E:\codex\aigc\output\aigc\G1-R6-MJ-execution-review-20260928.md`。
- [用户确认] 不登录、不重提、不新增费用；原图保持未修改。
## 用户自建 MJ 自动化与 R6 执行核验（2026-09-28）

| 线程 | 状态 | 目标 | 已验证结果 | 下一步 |
|---|---|---|---|---|
| 鲸鱼先导片 G1-R6 | 自建自动化四项均已完成，图像验收不通过 | 通过 Multica 本机桥和 MXAI 页面抽取 Midjourney v8.2 候选图 | R6-01 至 R6-04 作业日志均有“已选择尺寸 16:9、已点击立即生成、生成完成、serial、高清图校验”；`/control/state` 为 `done/ok`，原图存在。官方 MJ 网站队列与该自建渠道无关；费用字段未知 | 不合格图不交下游；如需重抽，先修正拼贴问题并按新批次授权 |