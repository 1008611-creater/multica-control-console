# 当前主控状态（2026-09-28，覆盖旧的离线样例结论）

## Multica 正式版收敛与源码上传（2026-09-28）

- [已验证] 当前唯一权威构建为 `dist/Multica-Control-Console-2026-09-28-product/`、配套 ZIP 与安装器；它包含桌面主程序与完整桥接源码。
- [已验证] 已按用户授权创建私有 GitHub 仓库 `1008611-creater/multica-control-console`，并将 42 个工作台源码、安装和构建文件推送到 `main`；提交 `773646a73493988b077509ce34ac49e16cf460ab`。
- [已验证] 上传内容未包含 `dist/`、`runtime/`、浏览器档案、生成图片、任务回执或项目提示词；31 个与正式包重叠的文件哈希一致。
- [已验证] 工作区 `npm run verify`、`npm test` 通过；源码副本的 Node 12 项、Python 3 项、PowerShell 14 个脚本语法检查和 .NET 桌面程序构建通过。
- [待处理] `dist/` 内仍有 4 组旧版文件夹、ZIP 和安装器。清理命令被主机策略拦截；未尝试其他删除方式，旧构建仍在原处。
- [待验证] 新电脑安装、纯净克隆后重建带内置运行时的完整安装包，以及真实 MXAI 登录/任务均未验收。
## 鲸鱼先导片 G1-R6 Midjourney 执行状态更正（2026-09-28）

- [已验证] 用户自建 Multica 自动化通过本机桥与 Playwright 适配器操作 MXAI 国内 MJ 生图页，页面选择 Midjourney v8.2。R6 四份日志都记录选择 16:9、点击生成、完成序列号和高清图校验，`/control/state` 返回 `done/ok`；本批自动化任务已完成。
- [已验证] MXAI 回执的计费字段为空，实际扣费未知；官方 Midjourney 网站队列不属于本批自动化的执行状态。
- [用户确认] 用户查看时官方 Midjourney 网站队列为空；该页面与经 MXAI 执行的自建自动化任务无关，不能用作本批状态依据。
- [已验证] R6 四张图均已返回并保存，但逐张目视都是 2×2 拼贴，不符合单张 16:9 静帧要求，视觉验收全部不通过。R5-01 重试是另一项 MXAI 本地结果，不属于 R6；其费用未知。更早 R5 四项因浏览器锁等待超时失败。
- 逐项序列号、原图路径、SHA-256、视觉结论与事后审查：`E:\codex\aigc\output\aigc\G1-R6-MJ-execution-review-20260928.md`。
- 当前处理：不登录、不重提、不修图、不产生新费用；等待用户另行明确授权后再决定后续。

## 一句话结论
[已验证] 控制台已从“离线批次样例”改为真实批次工作台入口：用户导入自己的任务清单后，页面才会调用本机真实桥；最多三并发；逐项读取 `/v1/jobs` 回执；失败不自动重提，只在桥明确“未扣费且允许重提”时提供人工重提。

## 对用户现在的影响
- [已验证] 页面不再展示或推进虚构的离线任务。
- [已验证] 可导入 JSON 数组或一行一条 JSON 的真实任务清单。
- [已验证] 检查批次不会登录、提交、扣费或生成图片。
- [已验证] “开始真实提交”被付费确认、桥连接和浏览器登录状态共同拦截。
- [已验证] 真实提交路径最多同时占用 3 个槽位，任务结束后才补位。
- [已验证] 当前批次、任务状态与作业号保存在本机浏览器；刷新后会回读作业，不会重复提交。
- [已验证] 失败不会自动重提；只有真实回执明确允许且确认未扣费时，才显示“人工重提”。

## 本轮实际产物
- `mj-automation/control/index.html`：重建为真实批次导入、授权闸门、三并发队列、作业/回执回读页面。
- `tmp/control-index-pre-real-batch-20260928.html`：本轮改动前页面备份。

## 验证证据
- [已验证] 内联 JavaScript `node --check` 通过。
- [已验证] `npm run verify` 通过。
- [已验证] `npm test` 通过（12 项 Node + 3 项 Python）。
- [已验证] 本地桥临时监听 8899 时，`GET /health`、`GET /control`、`GET /control/state` 成功回读；版本标记为 `2026-09-28-real-batch-01`，浏览器未运行时登录状态回读为未登录。
- [已验证] 浏览器检查通过：批次格式检查成功；未产生真实 `/v1/jobs` 请求；拦截式调度检查显示 4 项任务只先提交 3 项。
- [已验证] 刷新恢复检查通过：恢复原任务及作业号，未再次提交。
- [已验证] 视觉检查通过：页面为简体中文，未见旧的离线样例文案或乱码。

## 仍未验证
- [待核验] 用户本人在真实桥登录后，使用实际批次提交并读取真实平台回执。
- [待核验] 真实付费、成品回收、下载失败和跨重启恢复。
- [已验证] 源码页面与本机安装目录的页面及服务文件哈希一致；旧版页面和服务文件已在原目录留备份。
- [已验证] 已启动本机安装目录的控制台，`http://127.0.0.1:8765/control` 返回 200，桥版本为 `2026-09-28-real-batch-01`；浏览器未启动、未登录、未提交。
- [待核验] Windows 安装包尚未重建，发给他人使用的安装包仍是旧版。

## 安全边界
本轮没有登录、提交、付费生成、下载、自动重试或对外发送。

# Multica 当前主控状态

## 更新日期：2026-09-27（Asia/Shanghai）

## 当前结论

- [用户确认] 当前产品方向是全中文、可在 Windows 分发的本地抽卡生产工作台。
- [已验证] 本轮已统一核心产品文档与工程边界，并将 `/runtime/`、`/dist/` 加入忽略规则；这些目录仍留在原位。
- [已验证] 本轮最终运行 `npm run verify` 通过；`npm test` 通过 12 项 Node 测试与 3 项 Python 测试。
- [待验证] 临时隔离安装/升级、任务与回执等数据保留、另一台 Windows 首次启动，以及分发包内容的凭据扫描。
- [已验证] 当前中文页面已增加独立的离线批次队列和三并发状态展示；真实批次 manifest/attempts 接入、真实回执和成品回收仍待验证。
- [已验证] 本轮未登录、未发布、未付费生成、未自动重试、未下载或对外发送；未读取凭据、浏览器登录态或生成媒体。

## 当前阻塞与下一步

- [未完成] 不在同版本 `dist/` 上构建，除非先对现有产物完成备份与恢复验证；构建脚本会覆盖同名输出。
- [待验证] 后续价值最高的验收是隔离目录安装/升级数据保留和清单对照，当前尚未执行。
- [已验证] `assistant/THREADS.md` 登记当前议题；`docs/INDEX.md` 为文档入口。

本轮离线批次队列（2026-09-27）

- [已完成] `mj-automation/control/index.html` 已加入独立的“离线三并发样例”区域，保留原有真实单张作业入口。
- [已验证] 离线样例只在浏览器内存中运行，按钮逻辑不调用 `/v1/jobs`，不登录、不提交、不付费、不下载、不生成图片。
- [已验证] 样例初始包含 6 个任务，其中 3 个任务分别占用 1、2、3 号槽位，界面显示 `3 / 3`；其余任务分别处于排队、可安全重提失败和扣费未知阻塞。
- [已验证] 推进模拟会释放槽位并补位，安全重提只在有空槽且任务明确“未扣费（模拟）”时发生，活动任务数不会超过 3。
- [待验证] 尚未连接真实批次 manifest/attempts，也未验证真实桥回执、平台登录、付费生成、图片回收或下载。

## [待核验] 历史损坏记录（原始正文保留）

?????2026-09-27?Asia/Shanghai?

## ?????

[???] 26 ????????????????????????12 ?????????14 ????????????????? need_login?

## ??????

- [???] ?????8 ??????T01?T02?T03?T04?T05?T06?T07?T09??1 ????????CHAR_ZUO_MASTER??3 ??????SCENE_OCEAN?SCENE_HARBOR?SCENE_EUROPA??
- [???] ?? 12 ????? 2912?1632 ????????????????????????????????????????????
- [???] ????????FF_T08?FF_T10?CHAR_LAMBERT?SCENE_CABIN?SCENE_ARCHIVE?SCENE_DEEPSPACE??? 8 ??????
- [???] CHAR_LAMBERT ?????? FF_T03 ?? SHA-256/????????????
- [???] ??????????????????????????????

## ??????

- [?????] ????????????????????????????? 14 ??????????
- [?????] 12 ??????????????????????????????????

## ????

- ?????assistant/CURRENT.md
- ?????assistant/THREADS.md
- ?????projects/whale-pilot/project_state.yaml
- ?????projects/whale-pilot/asset-index.md
- ????mj-automation/scripts/production_machine.mjs
- ?????mj-automation/receipts/

## ????????

- [???] node --check mj-automation/scripts/production_machine.mjs
- [???] npm run verify
- [???] ?? 02?1 ????????20 ????????
- [???] ?? 01 retry-04?8 ????????
- [???] 12 ????????????????

## [待核验] 开头历史状态段落损坏说明

- [已验证] 文件开头至本说明之前的旧段落含实际问号字符，并非显示问题。
- [待核验] 其中的任务/资产数量、人物和场景状态、哈希与历史测试叙述无法从现存文件、回执和源码可靠还原；原段保留作损坏证据，不猜写。
- [已验证] 可回读引用路径存在：`assistant/CURRENT.md`、`assistant/THREADS.md`、`projects/whale-pilot/project_state.yaml`、`projects/whale-pilot/asset-index.md`、`mj-automation/scripts/production_machine.mjs`、`mj-automation/receipts/`。
- [已验证] 状态真源 `projects/whale-pilot/project_state.yaml` 当前为 `blocked`，视觉验收状态为 `pending_user`。本轮没有登录、付费生成或执行外部平台操作。
- [已验证] 本轮 `npm run verify` 通过，`npm test` 通过（12 项 Node、3 项 Python）；这不用于替代或猜写旧段落中的历史测试记录。

## AIGC dry-run implementation (2026-09-27)

- [已验证] 已落地离线 dry-run 资产：`projects/AIGC比赛抽卡/dry-run/README.md`、`fixture.json` 和 `scripts/aigc-dry-run.ps1`。
- [已验证] 脚本在隔离的 `tmp/aigc-dry-run-2026-09-27` 目录运行通过，生成模拟报告、模拟回执、状态映射和 handoff manifest。
- [已验证] 本轮未启动 Multica、未访问 `127.0.0.1:8765`、未生成图片、未调用付费接口。
- [待验证] 真实 Multica worktree 回传、真实桥提交、图片回收和实际扣费状态仍未验证。
- [已验证] `npm run verify` 通过；针对变更文件的事后复核确认脚本不含网络/进程调用，安全边界和隔离输出检查通过。

## Local browser control console (2026-09-27)

- [已验证] Previous automatic watchdog loop and starter process were stopped; no production_machine process is running.
- [已验证] Bridge restarted with control-console routes; GET /health returns bridge=2026-09-27-control-01.
- [已验证] GET /control/state returns watchdog.paused=true, watchdog.processRunning=false, browser.running=false.
- [已验证] Dashboard: http://127.0.0.1:8765/control
- [待用户决定] User completes login in the visible Edge window; no batch submission resumes automatically.
- [待验证] Actual platform login state and later paid generation remain unverified.
- [已验证] Python compile, Node syntax checks, npm run verify, and route readback passed. No post-coding-review skill file was available; manual changed-file and end-to-end route review was performed.

## MJ bridge retry gate (2026-09-27)

- [用户确认] 本轮只修复状态/重试闸门并补回归测试；禁止出图、重试、补下载、登录和重启。
- [已验证] `production_machine.mjs` 读取 `result.status` / `resultStatus` 与 camelCase/snake_case 重试标记；仅明确允许且确认未扣费的失败可自动重提；模糊 POST 不自动重提。
- [已验证] `/v1/jobs` 回读暴露业务状态、重试许可和扣费确定性；Node/Python 离线回归测试通过。
- [待验证] 未连接运行中的桥核对部署版本；本轮未启动桥、未登录、未调用生成或下载。
- [已验证] `npm test`（12 个 Node + 3 个 Python 回归测试）、`npm run verify`、Node 语法检查和 Python 编译通过；人工复核 POST→GET→业务状态归一化→重试闸门→回执路径完成。
- [已验证] 本轮未连接真实 MJ 桥、未出图、未重试、未补下载、未登录、未重启；运行态部署效果未验证。
- [已验证] `git diff --check` 只报告任务前已修改且本轮未触碰的 `mj-automation/scripts/watchdog_mj_bridge.ps1` 与 `projects/README.md` 文件末尾空行；保留用户现有内容。
- [待验证] 未提供/未发现 `post-coding-review` 技能文件，因此按变更文件和端到端执行路径完成人工事后审查。



## Local draw bridge workbench (2026-09-27)

- [done] `mj-automation/control/index.html` is a local workbench with prompt, aspect, version, label, request preview, paid confirmation, job polling, history, and receipts.
- [done] `mj-automation/scripts/server.py` serves the workbench, redirects `/` to `/control`, and reports build marker `2026-09-27-workbench-01`.
- [done] `mj-automation/scripts/mj_run.js` uses the bridge process Python executable for free lint checks, avoiding a service PATH false failure.
- [verified] Python and Node syntax checks, `npm run verify`, `GET /health`, `GET /`, `GET /control`, `GET /control/state`, free `POST /v1/maintenance {mode: lint}`, and a headless browser smoke test were read back successfully. The paid button stayed disabled until the checkbox was checked, the request preview opened, and no `/v1/jobs` call or image generation was made.
- [not verified] Browser visual acceptance, platform login, paid generation, and image recovery were not executed in this change.

## Portable package (2026-09-27)

- [已验证] Windows portable package created at `dist/Multica-Control-Console-2026-09-27/`.
- [已验证] ZIP artifact created at `dist/Multica-Control-Console-2026-09-27.zip`.
- [已验证] Package setup installed Python bridge dependencies and bundled Playwright runtime dependencies.
- [已验证] Package smoke test: setup -> start -> GET `/health` -> GET `/control` (HTTP 200) -> GET `/control/state` -> stop.
- [已验证] Package starts with watchdog paused and browser control stopped; no login or paid generation was triggered.
- [待核验] Distribution to another machine, Microsoft Edge availability, and real platform login remain unverified.- [已验证] Manual post-coding review checked the changed portable scripts, package manifest, credential/profile exclusion, start/stop path, control route, and final ZIP contents.
- [待核验] No second-machine install or real platform generation was performed in this review.

## 面向非技术用户的回复规范优化（2026-09-27）

- [已验证] 按用户指出的位置，将通用回复规则加入全局文件 `C:\Users\lsb\.codex\AGENTS.md`：使用直白中文、解释必要术语；需要用户操作时逐步说明地点/动作/预期结果；简单问答不强制套格式或附加提示词。
- [已验证] 补充区分样例检查与真实服务核对：未连接真实服务时，不得说真实返回内容已经验证；须说明还缺哪一步及其影响。
- [已验证] 项目文件 `AGENTS.md` 保留本项目进度汇报要求；付费生成、登录、发布和对外发送仍须用户当次明确授权。
- [已验证] `npm run verify` 通过；人工回读 `C:\Users\lsb\.codex\AGENTS.md` 确认通用回复规则和逐步操作指导写在全局文件中。仓库自检不覆盖该全局文件，因此对它做了人工复核。
- [待用户反馈] 后续可根据实际对话继续微调回复长短和术语解释方式。
## Local draw bridge workbench post-fix verification (2026-09-27)

- [verified] Restored mj-automation/control/index.html to valid UTF-8 after the previous localization pass introduced double-encoded text and changed watchdog handler names.
- [verified] Headless Playwright gate passed: title, online bridge state, jobs table, receipts table, preview flow, paid confirmation gate, and zero paid POST requests.
- [verified] GET /health, GET /, GET /control, GET /control/state, free lint POST, Python compile, Node syntax check, and 
pm run verify passed.
- [not verified] Platform login, paid generation, image recovery, and visual acceptance in a visible browser were not executed.

## Local installation and installer improvement (2026-09-27)

- [已验证] Installed copy is active at `E:\Multica-Control-Console`.
- [已验证] The installed bridge answers `GET /health` and the control page returns HTTP 200 at `http://127.0.0.1:8765/control`.
- [已验证] The installed instance starts with watchdog paused, browser control stopped, and zero running jobs.
- [已验证] Added `Install-Multica.cmd` and `portable_install.ps1`; the installer preserves the local browser profile and generated folders, then creates a Desktop shortcut.
- [待核验] Manual platform login, paid generation, and another-machine installation remain unverified.
## Local draw bridge product UI refresh (2026-09-27)

- [verified] Reworked mj-automation/control/index.html into a product-style local console with a navigation rail, hero area, status cards, studio form, local controls, current-job panel, history, and receipts.
- [verified] Preserved the paid confirmation gate, manual submit behavior, job polling, browser controls, watchdog controls, and free lint action.
- [verified] Restarted the local bridge so the served page is the refreshed file.
- [verified] Source review, Node syntax check, 
pm run verify, HTTP readback, free lint, desktop and mobile Playwright smoke, and screenshot inspection passed; no paid POST was made.
- [not verified] Visible-browser visual review by the user, platform login, paid generation, and image recovery remain untested.

## MJ bridge runtime read-only audit (2026-09-27)

## MJ bridge single real runtime acceptance (2026-09-27)

- [已验证] 仅提交正式素材 `whale-pilot-v1 / batch-01 / FF_T01_07S` 1 次；任务编号为 `whale-pilot-v1-batch-01-FF_T01_07S-audit_c4d1a360cd`，POST 返回 HTTP 202，`deduped=false`。
- [已验证] 真实查询返回 `status=done`、`resultStatus=need_login`、`ok=false`、无图片；任务数为 1，没有第二次提交。
- [已验证] 本轮未自动重试、未补下载、未登录、未重启；`retryAllowed`、`submitted`、`billed` 均为空，`chargeKnown=false`，实际扣除点数未知。
- [已验证] 原始任务回执位于 `E:\Multica-Control-Console\mj-automation\run\jobs\whale-pilot-v1-batch-01-FF_T01_07S-audit_c4d1a360cd.json`；审计回执位于 `mj-automation/receipts/whale-pilot-v1-batch-01-FF_T01_07S-audit-receipt.json`。
- [待用户决定] 平台登录仍是阻塞点；本轮不自动登录、不重试、不补下载、不重启。登录后的成功出图、扣费金额和下载回收仍未验证。
- [事后审查] 已复核提交次数、停止条件、真实回执和下游路径；本轮没有扩大到批量任务或自动恢复。

- [已验证] 只读访问当前运行中的 `http://127.0.0.1:8765`：`GET /health` 返回 HTTP 200，运行标记为 `2026-09-27-workbench-01`；`GET /control/state` 返回 watchdog 已暂停、浏览器未运行、当前任务数为 0；`GET /v1/jobs` 返回 HTTP 200、任务数为 0。
- [已验证] 工作区与已安装运行目录的 `production_machine.mjs` SHA-256 相同：`AC188CC8DB7F3704416B8AF80CB783D394C657FB388B909AE0E9B96ED8C7C712`；运行目录包含 `resultStatus`、`retryAllowed`、扣费确定性和不可自动重提状态闸门。
- [待验证] 当前没有真实任务，因此没有看到真实任务的 `queued`、`receipt_pending`、`download_failed`、`need_login` 或扣费字段；不能据此证明这些状态在真实任务上已经被桥正确返回和处理。
- [已验证] 本次只读审计没有提交任务、出图、重试、补下载、登录或重启。

## Multica 本地控制台界面与分发包更新（2026-09-27）

- [已验证] 权威页面源码为 `mj-automation/control/index.html`；源码、`E:\Multica-Control-Console` 安装版与 `dist/Multica-Control-Console-2026-09-27` 分发目录的 SHA-256 一致：`744900DC10B98F3F5B203CCA1DCCC70F4F57A896268DD66CA377B209B1651D99`。
- [已验证] 界面已统一字体层级、颜色、间距、控件、状态标签与轻动效；新增首次使用说明、中文状态/反馈、加载/离线/空数据状态；离线时付费提交按钮保持禁用。付费操作仍需勾选并弹窗二次确认。
- [已验证] Playwright 检查 1366×768、800×600、1920×1080 三种窗口宽度，页面无横向溢出；真实页面状态为服务正常、浏览器未启动、自动看护已暂停、0 个作业、0 条回执。离线时页面显示“连接失败/无法确认”，提交按钮禁用。
- [已验证] 安装版实际执行启动、`/health`、`/control`、`/control/state`、作业/回执读取、免费 lint、停止并确认 8765 端口关闭；随后重新启动并回读正常。浏览器未启动、无登录、无生成调用。
- [已验证] 首次免费 lint 暴露分发包漏装 `mj-automation/start_mj_bridge.ps1`，现已补入打包脚本与安装目录；修复后真实 `/v1/maintenance {mode: lint}` 返回 `lint_ok`。
- [已验证] ZIP 清单共 229 项；manifest 标明不含浏览器档案、凭据和生成媒体；归档中未发现浏览器档案载荷、空 `.browser-profile` 脚本目录、`config/local.ps1` 或凭据路径；所需启动脚本已包含。
- [已验证] `npm run verify` 通过；`npm test` 在使用安装版 Python 环境后通过（12 个 Node 测试、3 个 Python 测试）；`node --check` 与 Python 编译通过。全库 `git diff --check` 仅报告本轮未修改的 `mj-automation/scripts/watchdog_mj_bridge.ps1` 与 `projects/README.md` 末尾空行。
- [已验证] 安装升级时只同步程序页面、文档和脚本；本轮没有复制、清理或覆盖任务、回执、输出、配置或浏览器档案目录。
- [待验证] 另一台 Windows 电脑上的首次安装；真实平台登录、付费出图和图片回收均未执行。
- [待验证] 当前工作台展示的是抽卡桥单作业记录与回执，尚未显示 AIGC 批次 manifest/attempts 的三并发队列视图；既有 `production_machine.mjs` 的三并发与重提规则没有改动。
- [已验证] 未找到 `post-coding-review` 技能文件；人工复核了页面状态映射与离线/付费闸门、桥 API 路由、漏装脚本修复、安装目录同步排除项和最终 ZIP 清单。
## 单文件 Windows 安装器（2026-09-27）

- [已验证] 已生成单文件安装器 `dist/Multica-Control-Console-Setup-2026-09-27.exe`，大小约 4.05 MB；SHA-256：`657D25B2F4408C81B88BE7B397555D15AB04772B15734AB2CA9528AD2187D202`。
- [已验证] 安装器在临时目录完成首次安装和升级；升级前后浏览器档案、任务、回执、输出、归档和 `config/local.ps1` 测试文件哈希一致。
- [已验证] 临时安装版在独立端口启动成功；`/health`、`/control`、`/control/state` 通过，浏览器未启动、自动看护暂停；服务已停止。
- [已验证] `npm run verify` 通过；使用安装后的 Python 环境运行 `npm test`，12 项 Node 测试和 3 项 Python 测试通过。
- [已验证] 安装包清单注明不含浏览器档案、凭据和生成媒体；本轮没有登录、提交生成或调用付费接口。当前 8765 正式服务保持原样运行。
- [待核验] 普通桌面模式下的文件夹选择窗口尚未做人工目视验收；另一台 Windows 电脑首次安装尚未测试。
- [待用户决定] 安装器未做代码签名；若要公开分发并减少 Windows 安全提示，需要组织或个人代码签名证书。
- [已验证] 安装器封装程序和 Playwright 文件；Python 与 Node.js 仍需本机已安装，首次依赖准备需要联网。它不是离线免依赖安装包。
- [已验证] 未找到 `post-coding-review` 技能文件；人工复核了打包输入、安装目录复制排除项、升级保留路径、实际启动/停止链路和最终 EXE 清单。


## 单文件 Windows 安装器最终验收（2026-09-27）

- [已验证] 修复 `mj-automation/scripts/portable/portable_stop.ps1`：现在同时识别旧虚拟环境路径和内置 `runtime\python\python.exe`，内置 Python 启动的服务可被安全停止。
- [已验证] 重新生成最新版安装器：`dist/Multica-Control-Console-Setup-2026-09-27.exe`，SHA-256：`DA022799732830BAC9E6C8EC6458BD671E5AB82C9DF4D1CB4F7F4F8D9EF962E4`。
- [已验证] 全新临时目录安装成功；安装目录包含内置 Python 3.11、Node.js 和 Playwright，安装器返回代码 0。
- [已验证] 临时端口 `18767` 启动后，`/health`、`/control`、`/control/state` 均返回 HTTP 200；状态显示浏览器未启动、自动看护已暂停；随后停止成功且端口关闭。
- [已验证] 内置 Python 导入版本匹配：FastAPI 0.141.1、Pydantic 2.13.5、pydantic-core 2.46.5、Uvicorn 0.54.0。
- [已验证] 用最新版 EXE 对同一临时目录升级，配置、任务、回执、输出和归档哨兵文件的 SHA-256 全部保持不变。
- [已验证] `npm run verify` 通过；Node 12 项测试和内置 Python 3 项测试通过；相关 PowerShell 脚本语法检查通过。
- [已验证] ZIP 清单 5358 项；包含内置 Python/Node，未包含 `config/local.ps1`、浏览器档案内容、凭据或生成媒体；分发 ZIP SHA-256：`305482D754F9720F638B4A4D7AE914C04F811999B3FD06C82A65A58597218160`。
- [已验证] 未登录、未启动浏览器、未提交生成、未重试、未调用付费接口；正式 `127.0.0.1:8765` 服务未被本次临时验证停止。
- [待验证] 另一台 Windows 电脑首次安装、普通桌面文件夹选择窗口的人工目视验收、代码签名和真实平台操作仍未验证。
- [待说明] 直接运行仓库根目录 `npm test` 时，系统 Python 3.12 因未安装 `uvicorn` 导致 Python 测试导入失败；使用安装器内置 Python 运行同一组测试已通过。`git diff --check` 仍只报告本轮未修改的两个历史文件末尾空行。

## Multica 产品愿景基线（2026-09-27）

- [已完成] 已创建 `docs/multica-workbench-product-vision.md`，明确中文抽卡生产工作台的定位、页面结构、状态模型、三并发规则、失败重提边界、视觉规范和分阶段范围。
- [已验证] 已核对 `mj-automation/control/index.html` 和 `GET /control` 均为 UTF-8，源码及服务返回包含正常中文；旧状态文件中的问号属于历史编码损坏，未据此继续修改界面。
- [待用户决定] 是否按该规格进入控制台信息架构和界面重做。
- [未执行] 本轮没有登录、提交任务、付费生成、重试、下载或本地修图。

## 单文件安装器最终可验收版本（2026-09-27）

- [已验证] 修复升级复制逻辑：安装器现在逐文件合并到准确目标路径，不再生成 `mj-automation\mj-automation` 或 `runtime\runtime`；仅清理可识别的旧脚本重复目录。
- [已验证] 修复运行时选择逻辑：内置根 Python 缺少依赖时，会自动使用同一内置运行时下已有依赖的 `Scripts\python.exe`，不会错误调用缺少 pip 的根 Python。
- [已验证] 最新安装器：`dist\Multica-Control-Console-Setup-2026-09-27.exe`，SHA-256：`B11C1549A6B246D479DE661C079FB39C2BD416006C17CBAEC1E01BE2FEBA4C03`。
- [已验证] 最新 ZIP：`dist\Multica-Control-Console-2026-09-27.zip`，SHA-256：`CDCEA3D7422AC5457B03C669655DA45031A707A3F5DFEF18DB551D33F3C9C439`。
- [已验证] 全新临时目录安装成功；内置 Python、Node、Playwright 和环境记录均存在。
- [已验证] 临时端口 `18767` 的 `/health`、`/control`、`/control/state` 均返回 200；浏览器未启动、自动看护已暂停、作业和回执为 0；停止后端口关闭、运行记录清除。
- [已验证] 对含有旧嵌套目录的正式安装目录做升级：配置、任务、回执、输出和归档哨兵哈希全部不变；旧嵌套目录清除；源码与安装目录的页面、启动、环境准备和安装脚本哈希一致。
- [已验证] 正式安装目录再次启动并回读 `http://127.0.0.1:8765/health`、`/control`、`/control/state`；服务正常，浏览器未启动，自动看护已暂停；随后安全停止并确认端口关闭，再重新启动供用户验收。
- [已验证] 当前正式页面：`http://127.0.0.1:8765/control`，HTTP 200；当前真实状态为服务正常、浏览器未启动、自动看护已暂停、0 个作业、0 条回执。
- [已验证] `npm run verify` 通过；PowerShell 语法、Python 编译、12 个 Node 测试、3 个 Python 测试均通过。Python 测试使用安装器内置 Python 明确执行。
- [已知环境差异] 直接运行仓库根目录 `npm test` 会调用系统 `python`，当前系统解释器缺少 `uvicorn`，因此该命令的 Python 部分失败；使用安装器内置 Python 运行同一测试通过。软件安装包自身启动不受此影响。
- [已验证] 未登录、未启动浏览器控制、未提交生成、未重试、未下载图片、未调用付费接口。
- [待验证] 用户对安装窗口和页面的人工目视确认、另一台 Windows 电脑首次安装、代码签名、真实平台登录和付费操作。
## 单文件安装器与正式控制台最终验收补充（2026-09-27）

- [已验证] 使用 Playwright 会话 `multica-accept` 对正式页面 `http://127.0.0.1:8765/control` 做真实浏览器检查；页面标题为 `Multica · 本地抽卡工作台`。
- [已验证] 1366×768、800×600、1920×1080 三种窗口尺寸均无横向溢出；刷新后浏览器控制台无错误。
- [已验证] 付费提交按钮默认禁用，未勾选付费确认；本次只产生 GET `/control/state`，没有付费 POST、登录请求或生成请求。
- [已验证] 正式服务实时回读：`/health` 和 `/control` 为 HTTP 200，`/control/state` 显示服务正常、浏览器未启动、自动看护已暂停、作业 0、回执 0。
- [已验证] 当前正式服务仍保持运行，用户可直接打开 `http://127.0.0.1:8765/control` 验收。
- [未验证] 用户本人对页面和安装窗口的人工目视确认、另一台 Windows 电脑首次安装、代码签名、真实平台登录和付费操作仍未执行。
- [事后审查] 未找到可用的 `post-coding-review` 技能；已人工复核本轮实际变更的状态记录、安装器路径、正式服务回读、浏览器验收证据和未验证边界，没有把样例或无付费检查写成真实平台结果。

## 文档索引与项目状态漂移修复

- [已验证] 项目索引中的 `whale-pilot-v1` 状态已与 `project_state.yaml` 对齐为 `blocked`。
- [已验证] `docs/INDEX.md` 登记了当前全部 ADR 与 Multica 工作台产品愿景文档；验证脚本会检查 ADR 索引完整性及每个项目索引状态。
- [已验证] 根 `README.md` 技能数已改为四批 17 个，与 `skills/` 的 17 个 `SKILL.md` 和 `skills/README.md` 一致。
- [待验证] 等待本轮 `npm run verify`、`npm test` 和负向校验完成后更新最终结果。

### 本轮最终验证结果

- [已验证] `npm run verify` 通过；`npm test` 通过，包含 12 项 Node 测试和 3 项 Python 测试。
- [已验证] `docs/adr/` 中 7 个 ADR 均已登记在 `docs/INDEX.md`；验证脚本还会检查 ADR 漏登记和项目索引状态漂移。
- [已验证] `projects/README.md` 中三个项目状态与各自 `project_state.yaml` 一致；`whale-pilot-v1` 为 `blocked`。
- [已验证] 根 `README.md` 技能数现为四批 17 个，与实际 `SKILL.md` 数量一致。
- [已知遗留] `git diff --check` 对 `projects/README.md` 报告文件末尾多余空行；该文件本轮仅改了项目索引行，未调整既有空行。
- [待核验] `assistant/CURRENT.md` 与 `assistant/THREADS.md` 的历史段落存在问号损坏；无法从现存状态、回执和源码可靠还原的部分保持原样，不猜写。
- [事后审查] 未找到可用的 `post-coding-review` 技能；人工复核了本轮改动文件及 `npm run verify` → `scripts/verify.ps1` 的执行路径，并确认项目状态读取、ADR 索引检查均覆盖到实际文件；没有触碰分发产物或运行目录。

## 单文件安装器与正式控制台最终验收补充（2026-09-27）

- [已验证] 使用 Playwright 会话 `multica-accept` 对正式页面 `http://127.0.0.1:8765/control` 做真实浏览器检查；页面标题为 `Multica · 本地抽卡工作台`。
- [已验证] 1366×768、800×600、1920×1080 三种窗口尺寸均无横向溢出；刷新后浏览器控制台无错误。
- [已验证] 付费提交按钮默认禁用，未勾选付费确认；本次只产生 GET `/control/state`，没有付费 POST、登录请求或生成请求。
- [已验证] 正式服务实时回读：`/health` 和 `/control` 为 HTTP 200，`/control/state` 显示服务正常、浏览器未启动、自动看护已暂停、作业 0、回执 0。
- [已验证] 当前正式服务仍保持运行，用户可直接打开 `http://127.0.0.1:8765/control` 验收。
- [未验证] 用户本人对页面和安装窗口的人工目视确认、另一台 Windows 电脑首次安装、代码签名、真实平台登录和付费操作仍未执行。
- [事后审查] 未找到可用的 `post-coding-review` 技能；已人工复核本轮实际变更的状态记录、安装器路径、正式服务回读、浏览器验收证据和未验证边界，没有把样例或无付费检查写成真实平台结果。

## Multica 文件夹审计（2026-09-27）

- [已验证] 审计与后续改进提示词已保存到 `docs/multica-folder-audit.md`。
- [已验证] `npm test` 通过：12 项 Node 测试、3 项 Python 测试。
- [已验证] 本机 `runtime/` 约 53.9 MiB、`dist/` 约 665 MiB、`mj-automation/` 约 276.2 MiB；运行/分发目录边界和 Git 忽略策略需要先盘点再调整。
- [已验证] README、PROJECT_CONTEXT、AGENTS 与产品愿景对产品定位的描述不完全一致；CURRENT/THREADS 有历史乱码、重复和旧状态；README 技能数写 16，索引与实际 SKILL.md 数均为 17。
- [已验证] 文档索引更新后的 `npm run verify` 通过。
- [未执行] 没有删除、迁移、覆盖目录内容；没有登录、提交、付费生成或调用真实平台。
- [待验证] 跨设备安装及真实平台使用链路。

- [事后审查] 已读取并按 `E:\codex\aisp\aidaihuo-handoff-control\skills\post-coding-review\SKILL.md` 复核本轮审计文件、索引登记和提示词中的端到端完成门槛。

## Multica 文件夹审计追加事项（2026-09-27）

- [已验证] 根 README 已对齐至四批 17 个技能；`npm run verify` 通过，`npm test` 通过（12 项 Node、3 项 Python）。
- [已验证] `dist/`、`runtime/`、`.playwright-cli/` 的用途、大小、构建来源和 Git 状态已记录在 `docs/multica-folder-audit.md`；未删除、迁移、覆盖、忽略或重建目录。
- [已验证] CURRENT/THREADS 中的历史问号是文件真实内容。仍可回读的状态和路径已核对；不可还原的历史描述、数量及哈希已明确标记 `[待核验]`，损坏原文保留，未猜写。
- [事后审查] 按 `post-coding-review` 检查了 README 的技能导入指引、状态真源引用、改动文件和验证入口；本次未改运行逻辑、打包脚本或分发产物。
- [待验证] 跨设备安装、用户人工目视及真实平台登录/付费流程未执行；这些不属于本次授权范围。

## 鲸歌计划 P0 人物与场景拆解（2026-09-27）

- [用户确认] 片名为《鲸歌计划》。
- [已验证] 以用户指定的权威分镜为唯一剧情依据，已建立 S01–S12 镜头映射及 12 项 P0 人物、故事实体和场景需求。
- [已验证] 拆解说明：`projects/whale-pilot/p0-asset-breakdown.md`；机器可读清单：`C:\Users\lsb\Pictures\1aigc\鲸鱼\先导片\回执与清单\p0-asset-requirements.json`。
- [已验证] 修正海洋候选图序号；逐张看图后发现两张兰伯特文件分别是与 FF_T03 重复的木星屏幕图、及导出失败的波形图，已从人物候选中排除。其他 4 张候选图文件存在，等待你选格和目视验收。
- [待用户验收] 候选图未逐张目视审核；兰伯特与左小月外形、S01 深海地点、科研工作站归属及海难海域继续待确认。
- [已验证] 本轮没有新建或编辑图像，没有编写可提交的生图提示词，也没有登录或提交付费任务。
- [已验证] 本轮改动后 `npm run verify` 通过；P0 JSON 含 12 项资产和 12 个镜头，4 张剩余候选图文件存在。
- [事后审查] 已按 `post-coding-review` 技能复核资产来源、S01–S12 到 P0 资产的对应、角色设定卡依赖、清单中所有候选路径及“拆解后人工目视验收→提示词/新图授权→生成交付”后续门槛。
- [待用户验收] 候选图视觉适配性及分镜未写明的外貌/地点细节仍未确认。

## 正式控制台中文页面上线核对（2026-09-27）

- [已验证] 工作区权威页面 `mj-automation/control/index.html`、正式安装目录页面和最新分发目录页面均包含中文界面；`Local Draw Workbench`、`Service status` 等英文界面文字不存在。
- [已验证] 正式服务 `http://127.0.0.1:8765/control` 当前返回标题 `Multica · 本地抽卡工作台`，页面正文为中文；`/health`、`/control/state` 均返回 200。
- [已验证] 原因定位：之前运行中的服务曾停止，浏览器标签保留了旧页面内容；这不是中文源码没有部署。
- [已完成] 正式安装目录和分发目录的 `server.py` 已增加禁止缓存响应头，并已重启正式服务；页面响应包含 `Cache-Control: no-store, no-cache, must-revalidate, max-age=0`。
- [已完成] 已重建最新分发包和安装器，确保重新安装后也带有本次修复。
- [已验证] 未登录、未启动浏览器、未提交任务、未调用付费接口。
- [待用户操作] 当前已打开的旧标签需要刷新一次；建议按 `Ctrl+F5` 强制刷新，或打开带版本参数的 `http://127.0.0.1:8765/control?lang=zh-CN&v=20260927`。
- [事后审查] 已复核源码、安装目录、分发目录三份页面与服务响应；已运行 `npm run verify`；未将浏览器缓存现象误报为源码未上线。


## 当前主控状态：产品与分发边界收敛（2026-09-27）

- [用户确认] 当前工程目标是全中文、可在 Windows 分发的本地抽卡生产工作台，重点看清队列、最多三并发、真实回执、成品位置、失败原因和重提条件。
- [已验证] 本轮更新 README、PROJECT_CONTEXT、产品规格、产品愿景状态、架构说明、ADR-0007、验收清单、文档索引和忽略规则；保留了开工前已有改动与所有运行/分发目录文件。
- [已验证] `runtime/` 为本机依赖及浏览器档案位置，`dist/` 为版本化构建输出，`installers/install.ps1` 与构建脚本为源码，`mj-automation/receipts/` 为可核验回执；`.playwright-cli/` 当前保存页面快照和截图证据。
- [已验证] `/runtime/` 与 `/dist/` 现由 `.gitignore` 排除；文件未删除或迁移。已有分发件仍在原位。
- [已验证] `npm run verify` 和 `npm test` 通过（12 项 Node、3 项 Python）。
- [已验证] 安装器升级源码按合并复制并跳过本机任务、回执、输出、归档、浏览器档案和 `config/local.ps1`；新包不覆盖已存在的 Python 运行环境。
- [待验证] 未在临时隔离目录实测安装/升级/数据标记保留，也未核实另一台 Windows 机器上的启动；分发清单与包体核对尚未完成。
- [未执行] 未登录、未提交、未付费生成、未发布、未下载；没有读取浏览器档案内容或凭据。
- [待处理] 历史损坏段落仍保留原文；已明确不可恢复部分不猜写。本轮未重排或覆盖旧状态。

## 手动登录浏览器反复刷新修复（2026-09-27）

- [已验证] 原因一：登录按钮复用了生成流程的导航函数；未登录时会等待创作面板并可能重载页面。
- [已验证] 原因二：强制关闭浏览器后，旧 PID 会留在状态文件中，控制台可能误判浏览器仍在运行，导致再次打开失败。
- [已完成] `mxai_adapter.js` 增加手动登录模式：只导航一次，不等待创作面板，不自动重载，不清理登录弹窗。
- [已完成] `browser_control.js` 已改为使用手动登录模式。
- [已完成] `server.py` 在 Windows 上改用 `tasklist` 核对浏览器 PID，避免旧 PID 阻塞重新打开。
- [已验证] 正式服务已重启；旧浏览器进程已清理并重新启动，状态为 `not_logged_in`，日志出现“登录页面已打开，等待用户手动登录；不会自动重载或关闭登录弹窗”。
- [已验证] 当前没有登录、没有提交生成、没有调用付费接口。
- [已完成] 最新 EXE 和 ZIP 已重新构建。
- [待用户操作] 用户现在可在已经打开的浏览器窗口中手动登录；登录期间控制台不会替用户提交任务。
- [事后审查] 已检查源码、安装目录、分发目录、运行日志、浏览器状态和重启链路；`npm run verify`、Python 编译、Node 语法检查均通过。

## 第五批技能导入（2026-09-27）

- [用户确认] 用户明确授权将第五批 `mj-asset-card-drawer` 导入 Multica，并要求先核查入口和影响，再执行、验证。
- [已验证] 使用 Multica CLI 的本地归档导入入口；导入前技能库有 18 项且没有同名技能，使用 `--on-conflict fail`，没有覆盖已有技能。
- [已验证] 导入后技能库有 19 项；`mj-asset-card-drawer` 唯一记录 ID 为 `21e5734d-b3f1-42e9-8537-95cad9dc6f63`。技能正文及 `references/mj-prompt-spec.md`、`references/whale-trailer-asset-map.md` 的远端 SHA-256 与本地副本一致。
- [已验证] 导入归档仅包含技能正文与两份配套参考文件。没有挂载智能体、修改旧技能、提交生成或调用付费接口。
- [待验证] `SKILL.md` 中指向项目提示词的相对链接不属于导入归档；Multica 技能环境能否通过该链接访问项目提示词尚未核验。
- [事后审查] 已复核导入入口、归档内容、远端唯一条目、内容哈希与参考文件清单。技能已到技能库可读取状态；尚未验证智能体挂载后的调用效果。

## 安装窗口可读性改进（2026-09-27）

- [已验证] 原因：旧版 `installers/install.ps1` 每次都强制打开 Windows 系统“浏览文件夹”窗口，并要求用户自己找安装目录；即使电脑已有安装，也没有自动识别，所以用户会看到目录树和“升级时选原目录”的技术说明。
- [已完成] 安装器现在先自动检查常见安装位置。找到旧版后显示“更新 Multica 本地工作台”和“开始更新”；首次安装显示“安装 Multica 本地工作台”和默认位置。只有首次安装用户主动点“选择其他位置…”时才打开文件夹选择窗口。
- [已完成] 窗口用中文说明软件用途、安装位置、更新时保留的本机内容；取消、开始安装/更新均有清楚按钮。没有改动当前正式安装目录和 8765 运行服务。
- [已验证] 新 EXE：`dist/Multica-Control-Console-Setup-2026-09-27-ux.exe`，SHA-256：`E4C8D1390AD0CC2C5F7AA4A2AD28CD8B01127B04B1CAD40E3FDAEA112F542814`；配套 ZIP：`dist/Multica-Control-Console-2026-09-27-ux.zip`。
- [已验证] 使用新 EXE 在临时目录完成首次安装和升级；升级任务哨兵 SHA-256 前后相同；安装器返回代码为 0。PowerShell 脚本语法检查及 `npm run verify` 通过。
- [已验证] 正式 `http://127.0.0.1:8765/health` 回读正常；本轮未登录、未启动/停止浏览器、未提交任务、未出图或调用付费接口。
- [待验证] 本轮无法从当前桌面控制能力目视检查新的安装窗口；其他电脑安装和代码签名也未测试。安装器识别旧版使用 `E:\Multica-Control-Console` 与 `%LOCALAPPDATA%\Multica-Control-Console` 两个常见位置。
- [事后审查] 按 `E:\codex\aisp\aidaihuo-handoff-control\skills\post-coding-review\SKILL.md` 审查实际安装入口、默认路径识别、首次安装/更新分支、取消行为、保留用户数据的合并复制链路、EXE 内嵌脚本、临时安装/升级回执和当前运行服务。未目视验收界面，因此不把界面视觉效果记为已验证。

## 安装器最终版本补充（2026-09-28）

- [已验证] 按最终本机日期重新构建可交付版本：`dist/Multica-Control-Console-Setup-2026-09-28-ux.exe`，SHA-256：`0B2228C1651E65AFD83B758B38C513DCC5D212DED5488135F61FE82716E4F812`。
- [已验证] 配套 ZIP：`dist/Multica-Control-Console-2026-09-28-ux.zip`；包清单版本为 `Multica-Control-Console-2026-09-28-ux`。
- [已验证] 用该最终 EXE 对隔离临时安装目录升级，返回代码 0；任务哨兵文件 SHA-256 升级前后均为 `3EAFA0F7E04E1E96CBDF40FFF9DED3B247AE101161F9EC7771C71D2ACD9ACF94`。
- [已验证] 正式安装副本和正在运行的服务没有被升级或停止；界面目视验收仍待用户本人确认。

## 离线批次尝试与回执详情（2026-09-27）

- [已验证] `mj-automation/control/index.html` 的离线批次样例已加入每项任务的尝试记录、回执状态/结果、扣费结论、失败原因、重提条件和成品位置详情。
- [已验证] 批次表新增“查看详情”；推进模拟完成、队列补位和安全重提时，详情面板会同步更新最新尝试和模拟回执。
- [已验证] 样例回执明确写明“仅模拟”；成品位置在离线样例中写为「缺」，不生成本地图片或真实文件。
- [待验证] 真实 `manifest/attempts` 只读接入、真实桥回执、平台登录、付费生成和成品回收仍未验证。
- [待验证] 未重新构建或覆盖 `dist/` 与安装包。
- [已验证] 本轮未连接桥、未登录、未提交、未扣费、未下载、未生成图片。


## 安装器交付基准更正（2026-09-27）

- [已失效] 前文 `2026-09-27-ux.exe` 哈希 `E4C8...` 属于旧构建；安装说明尚未区分首次安装与更新。
- [已失效] `2026-09-28-ux` 是较早生成的测试构建，且日期晚于本项目当前日期；不要分发或使用它。
- [已验证] 当前应使用的最终 EXE：`dist/Multica-Control-Console-Setup-2026-09-27-ux.exe`，SHA-256：`A209C5AEA9C9A118CC94B307E81B2E7FD03E12CE104D1BE8B270F182AD86722E`。
- [已验证] 配套 ZIP：`dist/Multica-Control-Console-2026-09-27-ux.zip`；清单版本为 `Multica-Control-Console-2026-09-27-ux`。
- [已验证] 最终 EXE 在隔离临时目录完成首次安装和升级；两个安装步骤均返回 0，升级前后任务哨兵 SHA-256 一致。`npm run verify` 通过。
- [待验证] 新安装窗口没有进行桌面目视验收；正式安装目录未升级，当前运行服务未停止。
- [???] ????????????????????????????????????????????????????????
- [???] ??????????????? VM ???`npm run verify` ? `npm test` ????

## 桌面产品版交付（2026-09-28）

- [已验证] 新增 `desktop/Multica.Desktop.csproj` 与 `desktop/Program.cs`，产出自包含 `win-x64` 桌面主程序 `Multica.exe`。
- [已验证] 桌面主程序提供中文状态总览和 5 个常用入口，启动时接管已有本地桥或从当前安装目录启动内置桥。
- [已验证] `Start-Multica.cmd` 优先启动 `Multica.exe`，旧脚本入口仍保留为回退路径。
- [已验证] `scripts/build_multica_portable.ps1` 和 `scripts/build_multica_installer.ps1` 已纳入桌面 EXE 构建；新产物位于 `dist/Multica-Control-Console-2026-09-28-product/` 和对应安装器。
- [已验证] 本机启动 EXE 后，`http://127.0.0.1:8765/health` 与 `/control/state` 成功回读；未登录、未提交、未付费、未下载。
- [待核验] 另一台 Windows 首次安装、无 .NET 环境启动、代码签名、视觉验收和真实平台任务。
- [事后审查] 已检查桌面主程序、启动脚本、构建脚本、分发清单和真实启动链路；没有覆盖用户原有修改，也没有读取或输出凭据。
- [已验证] 新版桌面程序已更新到本机安装目录 `E:\Multica-Control-Console\Multica.exe`；任务、回执、输出、配置和浏览器档案的文件数与总字节数更新前后保持一致。


## Global response-format plugin enabled (2026-09-28)

- [已验证] Codex plugin `i-have-adhd` was already installed but disabled; it is now enabled at version `0.3.0`.
- [已验证] GitHub source: `ayghri/i-have-adhd`, commit `839872f9d1cd634fed642b4589ce7226199cc15f`. Installed `SKILL.md` SHA-256 matches the clone.
- [待核验] Verify skill-menu discovery in a new session after restart; this thread is applying the skill explicitly.


## G1-R5 MJ ?????2026-09-28?

- [????] ?????? Multica ?? G1-R5 ? 01?04 ?? Midjourney ????????????
- [???] Multica `http://127.0.0.1:8765` ?????? 200?????? `2026-09-28-real-batch-01`?
- [???] ?? `/control/state` ????????????????? `/control/browser/start` ???? Edge ?????
- [?????] ??????? Edge ?????????????????????? 01?04????????????????????????


## G1-R5 MJ ?????2026-09-28?

- [????] ??????? Multica ?? G1-R5 ? 01?04?????????
- [???] ??????? `logged_in=true`?
- [???] 4 ?????? HTTP 202?`deduped=false`?`status=running`????????
  - `G1-R5-01_b5e507bd32`
  - `G1-R5-02_1ca7fb8f1b`
  - `G1-R5-03_957f934d96`
  - `G1-R5-04_6fc0177fdb`
- [???] 4 ?????? Multica ?????????????????????????????????????

## 用户自建 MJ 自动化：R6 执行状态（2026-09-28）

- [已验证] 本机桥将 Midjourney v8.2 请求交给用户自建的 MXAI 页面自动化：`server.py` → `mj_run.js` → Playwright `mxai_adapter.js`。这不是依赖官方 Midjourney 网站队列的执行路径。
- [已验证] 四项 R6 作业日志均记录页面选择 16:9、点击生成、收到 serial 与下载按钮、高清文件校验通过；Multica `/control/state` 当前回读均为 `done/ok`，文件在输出目录。
- [已验证] 只读回读时桥服务健康接口正常；浏览器当前已停止、当前登录状态为 false、watchdog 暂停。此当前快照不覆盖已保存作业历史。
- [待核验] 四项实际扣费。R6 四张图因 2×2 拼贴视觉验收未通过。