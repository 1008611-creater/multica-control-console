# HANDOVER_TO_AI.md — Multica 抽卡工作台 · 交接给「对方电脑上的 AI」

> 本文件写给**另一台电脑上的 AI 助手**（Claude Code / Codex / DSH / Cursor 等）。
> 人只需要说一句：「读 HANDOVER_TO_AI.md，按里面的步骤把环境装好并跑起来」。
> 版本对应：发行版 `2026.10.08.2`；桥版本见 `GET /health` 的 `bridge` 字段。

---

## 0. 一句话说明这是什么

**Multica 抽卡工作台** = 一个本机运行的 **Midjourney（MXAI 中文站）批量出图桥**。

- 一个本地 FastAPI 服务（默认 `http://127.0.0.1:8765`），用 Playwright 驱动 **Microsoft Edge** 操作 MXAI 生图页
- 支持批量提交、排队、三路调度、结果下载、内容校验、回执台账、本地工作台界面
- 有 **三个入口**：HTTP API、MCP（stdio）、CLI
- 出图是**付费动作**（约 6 积分/张），必须由**人**逐批授权；软件本身不会自动付费

**它不是**：不是模型服务、不代理 API、不共享账号。**每个使用者必须用自己的 MXAI 账号登录。**

---

## 1. 先决条件（在目标电脑上确认）

| 项 | 要求 | 检查命令 |
|---|---|---|
| 操作系统 | Windows 10/11 x64 | — |
| Microsoft Edge | **必需**（Playwright 驱动它） | `Test-Path "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"` |
| Edge WebView2 Runtime | 桌面版需要 | 见 README_FIRST_RUN.md |
| Python | **3.10+**（仅 Setup 时需要；会建独立 venv） | `python --version` |
| Node.js | **18+**（仅 Setup 时需要；用于装 Playwright） | `node --version` |
| 磁盘 | 预留 **3 GB** | — |
| 网络 | 能访问 MXAI 站点；如走代理需自备 | — |

> Setup 会把 Python 依赖装进 `runtime/python`、把 Playwright 装进 `runtime/node_modules`，
> **不会污染系统 Python**。`runtime/` 已被 .gitignore 排除，不会入库。

---

## 2. 拉到本地并跑起来（AI 执行清单）

```powershell
# ① 克隆（浅克隆即可，历史很大）
git clone --depth 1 https://github.com/1008611-creater/multica-control-console.git
cd multica-control-console

# ② 准备运行环境（建 venv、装 fastapi/uvicorn/pydantic、装 playwright）
.\Setup-Multica.cmd
# 成功标志：输出「环境准备完成：<路径>」，且生成 runtime\setup.json

# ③ 启动本地桥
.\Start-Multica.cmd
# 成功标志：浏览器打开 http://127.0.0.1:8765/control 工作台

# ④ 自检
Invoke-RestMethod http://127.0.0.1:8765/health
```

**⑤ 人工登录（红线，AI 不得代做）**
在工作台点「打开登录浏览器」，或调用：

```powershell
Invoke-RestMethod -Method Post http://127.0.0.1:8765/control/browser/start
```

会弹出一个可见 Edge 窗口。**请人本人在窗口里登录 MXAI**，登录完关掉该窗口（登录态会保存在
`runtime/browser-profile`，已被 .gitignore 排除）。

**⑥ 验证登录成功**

```powershell
(Invoke-RestMethod http://127.0.0.1:8765/control/state).browser
# 期望：loggedIn=True / loginState=logged_in
```

---

## 3. 三个入口怎么用

### 入口 A：HTTP API（推荐，最稳）

| 方法 | 路径 | 用途 | 费用 |
|---|---|---|---|
| GET | `/health` | 自检（runner/adapter/profile/node_modules/输出目录） | 免费 |
| GET | `/v1/models` | 返回 `midjourney` | 免费 |
| POST | `/v1/jobs` | **提交出图，立刻返回作业号**（推荐） | 付费 ~6 积分 |
| GET | `/v1/jobs?tail=20` | 列最近作业 | 免费 |
| GET | `/v1/jobs/{jobId}` | 查单个作业结果 | 免费 |
| POST | `/v1/maintenance` | 只读维护：lint / lint-prompt / env / netstat / autostart / aspect-check / dl-serial | 免费 |
| POST | `/v1/images/generations` | 同步出图（会长时间占连接，不推荐） | 付费 |

**提交出图（两段式，推荐）**

```powershell
$body = @{
  prompt = "极广深焦太空全景，一艘外星难民战舰……"   # 纯正文，禁止出现 -- 参数
  aspect = "16:9"                                     # 1:1 1:2 16:9 9:16 4:3 3:4 3:2 2:3
  version = "v8.2"
  label  = "MY_JOB_01"
  params = @{ stylize = 200; chaos = 4 }              # 高级参数走这里，不写在正文
} | ConvertTo-Json
$j = Invoke-RestMethod -Method Post -Uri http://127.0.0.1:8765/v1/jobs `
     -ContentType "application/json; charset=utf-8" `
     -Body ([System.Text.Encoding]::UTF8.GetBytes($body))
$j.jobId     # 记下来；约 20–40 分钟后回来查
```

**查结果（免费，可反复查）**

```powershell
$r = Invoke-RestMethod "http://127.0.0.1:8765/v1/jobs/$($j.jobId)"
$r.status          # running / done / stale / unknown
$r.images          # done 时给出本地高清图路径
```

**免费补下载（按站内 serial，不重复扣费）**

```powershell
$m = @{ mode = "dl-serial:2109880069374611456:MY_JOB_01" } | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri http://127.0.0.1:8765/v1/maintenance `
  -ContentType "application/json; charset=utf-8" `
  -Body ([System.Text.Encoding]::UTF8.GetBytes($m))
```

### 入口 B：MCP（stdio，适合接 AI 客户端）

原项目 `mxai_mcp_server.js` 提供 8 个工具：`mxai_start`、`mxai_status`、`mxai_dismiss`、
`mxai_diag`、`mxai_generate`、`mxai_generate_batch`、`mxai_download_latest`、`mxai_close`。

在 MCP 客户端配置里以 stdio 方式 spawn 即可。

> ⚠️ MCP 默认走本地控制平面（`RPA_CONSOLE_URL`，即 ai-rpa-console 的 `server.js`），
> 而它的 `executeBatch()` 对 `image` 类型批次是**硬阻断**的。
> **接 Multica 时优先用入口 A（FastAPI）**，绕开这个限制。

### 入口 C：CLI（调试用）

```powershell
cd mj-automation\scripts
node mj_run.js --prompt "……" --aspect 16:9 --prefix MY_JOB_01
node dl_by_serial.js 2109880069374611456 MY_JOB_01
```

---

## 4. 出图前必做的免费闸门（每次开工都跑）

```powershell
# ① 脚本语法体检（只解析不执行）
$m = @{ mode = "lint" } | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri http://127.0.0.1:8765/v1/maintenance -ContentType "application/json" -Body $m

# ② 提示词风险扫描（v8.2 解析器会把全大写拉丁缩写、带连字符合成词误判成未知参数 → 整单失败）
$m2 = @{ mode = "lint-prompt"; file = "D:\我的提示词目录" } | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri http://127.0.0.1:8765/v1/maintenance -ContentType "application/json" -Body $m2
#   dirty 必须为 0；referenceOnly 的英文备份块只提示、不阻断

# ③ 画幅档位是否真被选中
$m3 = @{ mode = "aspect-check:16:9" } | ConvertTo-Json
Invoke-RestMethod -Method Post -Uri http://127.0.0.1:8765/v1/maintenance -ContentType "application/json" -Body $m3
#   chipsAfter 里目标档位应带 selected-item
```

也可直接双击 `mj-automation\4_出图前自检.cmd`。

---

## 5. 已知问题与规避（交接必读）

| # | 现象 | 原因 | 规避 |
|---|---|---|---|
| 1 | `Start-Multica.cmd` 报 `Start-Process : Item has already been added. Key in dictionary: 'NO_PROXY'` | 系统环境变量同时存在 `NO_PROXY` 与 `no_proxy`（大小写变体），PowerShell 建环境字典时冲突 | 删除重复项之一；或直接用 `runtime\python\Scripts\python.exe server.py` 手动起（需自行注入环境变量，见 §7） |
| 2 | 提交返回 422 `请将 -- 参数移出正文` | `/v1/jobs` **禁止正文出现 `--`** | 参数走结构化 `params` 字段；画幅走 `aspect` 字段 |
| 3 | 点了生成但没建任务、没扣费 | 平台对**短间隔连续提交**会静默拒收 | 每条提交后**按卡片文本核对**，间隔 ≥20 秒，失败重试 |
| 4 | 连续提交大量被拒 | **账号并发上限 = 3** | 用**滑窗流水线**（始终保持 ≤3 在飞），不要"先全提交再等" |
| 5 | 任务显示「已失效（积分已自动退回）」 | 站点队列过载 | 失败会自动退款，**重提安全**；控制提交节奏 |
| 6 | 旧卡片查不到（`getElementById` 返回 null） | 卡片列表虚拟化，只渲染最近 10 张 | 下载前先**滚动加载**；id 必须是完整 `serial-<数字>` |
| 7 | 高级参数没生效 | `setAdvancedParam()` 是**空操作** | `--stylize N --chaos M` 必须写进提示词文本（`--ar` 例外，走页面档位） |
| 8 | 单张很慢 | 站点队列 20–40 分钟/张 | 属正常；用三路并发摊平 |

---

## 6. 安全红线（**AI 必须遵守**）

1. **绝不**把 `runtime/`、`.browser-profile/`、`mj-automation/run/`、`mj-automation/output/`、`deliverables/` 提交进仓库。
   → 这些含**登录态 Cookies**、任务、回执与成品图。
2. **绝不**代人在登录窗口里输入账号密码。登录只能由人本人完成。
3. **绝不**在未取得本人当次授权时提交付费生成。
4. **绝不**把 `*.env`、`*.key`、`*credential*.json`、`*secret*.json`、`cookies*.json` 入库。
5. 提交前自查：`git status --porcelain` 里**不得**出现 `browser-profile`、`Cookies`、`Login Data`、`Local State`。

---

## 7. 手动起桥（当 `Start-Multica.cmd` 不可用时）

```powershell
$env:MJ_BRIDGE_PORT      = "8765"
$env:MJ_OUTPUT_DIR       = "<仓库>\mj-automation\output"
$env:MJ_JOBS_DIR         = "<仓库>\mj-automation\run\jobs"
$env:MJ_RECEIPTS_DIR     = "<仓库>\mj-automation\receipts"
$env:MXAI_PROFILE        = "<仓库>\runtime\browser-profile"
$env:MXAI_LOCK_FILE      = "<仓库>\runtime\browser-profile.bridge.lock"
$env:MXAI_NODE_MODULES   = "<仓库>\runtime\node_modules"
$env:MJ_BRIDGE_TIMEOUT_MS = "1200000"
cd <仓库>\mj-automation\scripts
& "<仓库>\runtime\python\Scripts\python.exe" server.py
```

---

## 8. 交接完成判据（AI 自检清单）

- [ ] `git clone` 成功，工作区无 `runtime/`（首次）
- [ ] `Setup-Multica.cmd` 输出「环境准备完成」
- [ ] `runtime/setup.json` 存在，`edgeDetected = true`
- [ ] `GET /health` 返回 `ok: true`、`model: midjourney`
- [ ] **人**已完成 MXAI 登录；`/control/state` 的 `browser.loggedIn = true`
- [ ] `mode = lint` 全绿
- [ ] `aspect-check:16:9` 的 `chipsAfter` 里 16:9 带 `selected-item`
- [ ] **取得本人本次付费授权**后，才提交第一张测试图
- [ ] 确认 `git status` 无任何登录态/密钥文件

---

## 9. 目录速查

| 路径 | 内容 | 是否入库 |
|---|---|---|
| `mj-automation/scripts/` | 桥、适配器、runner、校验器 | ✅ 入库 |
| `mj-automation/control/` | 本地工作台前端 | ✅ 入库 |
| `runtime/` | Python venv、Playwright、**浏览器登录档案** | ❌ 排除 |
| `mj-automation/run/` | 任务、进度、批次、日志 | ❌ 排除 |
| `mj-automation/output/` | **出图成品** | ❌ 排除 |
| `mj-automation/receipts/` | 回执台账 | ❌ 排除 |
| `deliverables/` | 项目交付物（非本仓库内容） | ❌ 排除 |

---

## 10. 相关文档

- `README_FIRST_RUN.md` —— 面向人的首次运行说明（界面操作、快捷键、数据保留）
- `mj-automation/01_能力地图与调用方式.md` —— 三条入口的完整字段与返回值
- `mj-automation/02_修复清单与验收标准.md` —— 历史修复项
- `mj-automation/03_运维手册.md` —— 启停、看护、自愈
- `docs/workbench-authority-2026-10-08.md` —— 本地工作台权威记录
