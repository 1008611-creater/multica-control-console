# =====================================================================
# MJ 生图桥接服务 · 一键启动（Windows PowerShell）
# =====================================================================
#
# 它做的事：
#   1. 检查代理是否在线（MXAI 联网前置条件，最容易忘、也最容易全批卡死）
#   2. 检查 python / fastapi / uvicorn 是否就绪，缺了就提示怎么装
#   3. 设好全部环境变量（不写进任何文件，只作用于本窗口）
#   4. 启动 FastAPI 服务，监听 127.0.0.1:8765
#
# 用法：
#   cd E:\codex\multica\mj-automation
#   powershell -ExecutionPolicy Bypass -File .\start_mj_bridge.ps1
#   powershell -ExecutionPolicy Bypass -File .\start_mj_bridge.ps1 -Yes   # 无人值守（代理没开也不问）
#
# 红线：本脚本不登录、不出图、不发布。付费出图必须由你本人按批次授权。

param(
    # 加 -Yes 后，代理没开也不问、直接继续（供后台/无人值守重启用；交互式仍会问你）
    [switch]$Yes,
    # 指定后，服务输出同时落盘到该文件（供看护脚本/计划任务无人值守时排查用）
    [string]$LogFile = '',
    # 已在运行且健康时直接退出，避免重复起第二个进程抢同一个端口
    [switch]$NoDuplicate
)

$ErrorActionPreference = 'Stop'

$Root       = 'E:\codex\multica\mj-automation'
$ScriptsDir = Join-Path $Root 'scripts'
$ProfileDir = 'E:\codex\niannianai\zhuanhuiyuangong\ai-rpa-console\.browser-profile'
$NodeMods   = 'E:\codex\niannianai\zhuanhuiyuangong\ai-rpa-console\node_modules'

function Write-Step($t) { Write-Host ('==> ' + $t) -ForegroundColor Cyan }
function Write-Ok($t)   { Write-Host ('    OK  ' + $t) -ForegroundColor Green }
function Write-Bad($t)  { Write-Host ('    !!  ' + $t) -ForegroundColor Yellow }

Write-Host ""
Write-Host 'MJ 生图桥接服务 · 启动检查' -ForegroundColor White
Write-Host ('=' * 62)

# --- 0. 单实例守卫（2026-09-12 新增） --------------------------------
# 看护脚本或计划任务可能在服务已经活着时又调一次；这里先看一眼，
# 已经健康就直接退出，避免第二个进程抢同一个端口、也避免重复启动浏览器。
$ProbePort = if ($env:MJ_BRIDGE_PORT) { [int]$env:MJ_BRIDGE_PORT } else { 8765 }
$alreadyUp = $false
try {
    $h = Invoke-RestMethod -Uri ('http://127.0.0.1:' + $ProbePort + '/health') -TimeoutSec 6
    if ($h -and $h.ok) { $alreadyUp = $true }
} catch { $alreadyUp = $false }
if ($alreadyUp) {
    # -NoDuplicate 供计划任务/看护调用：安静退出，不刷屏（日志里仍留一行痕迹）。
    if (-not $NoDuplicate) { Write-Ok ('服务已在运行且健康（build=' + $h.bridge + '），无需重复启动。') }
    if ($LogFile) { try { Add-Content -Path $LogFile -Value ('[' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '] already-running build=' + $h.bridge) -Encoding UTF8 } catch { } }
    exit 0
}

# --- 1. 代理 ---------------------------------------------------------
Write-Step '检查代理 127.0.0.1:7897'
$proxyOk = $false
try {
    $proxyOk = Test-NetConnection 127.0.0.1 -Port 7897 -InformationLevel Quiet -WarningAction SilentlyContinue
} catch { $proxyOk = $false }
if ($proxyOk) {
    Write-Ok '代理在线'
} else {
    Write-Bad '代理没开！MXAI 页面会一直卡在加载，任务会全批失败。'
    Write-Bad '请先打开代理软件，再重新运行本脚本。'
    if ($Yes -or -not [Environment]::UserInteractive) {
        Write-Bad '（-Yes 已指定，跳过询问，继续启动；出图前请务必确认代理已开）'
    } else {
        $answer = Read-Host '代理未开，仍要继续吗？(y/N)'
        if ($answer -ne 'y') { Write-Host '已取消。'; exit 1 }
    }
}
# [FIX-20260916-VENV] 优先用本目录专用环境 .venv
# 为什么：系统里的 anaconda fastapi 是残缺安装（缺 params.py），import 就报错；
# 专用环境把桥的依赖隔离出来，不动系统 Python。
$pyExe = $null
$venvPy = Join-Path $Root '.venv\Scripts\python.exe'
if (Test-Path $venvPy) {
    $pyExe = $venvPy
    Write-Ok ('专用环境 python -> ' + $pyExe)
} else {
    $py = (Get-Command python -ErrorAction SilentlyContinue)
    if (-not $py) {
        Write-Bad '找不到 python，也没找到专用环境 .venv。'
        exit 1
    }
    $pyExe = $py.Source
    Write-Ok ('python -> ' + $pyExe)
}

$missing = @()
foreach ($mod in @('fastapi', 'uvicorn')) {
    & $pyExe -c ("import " + $mod) 2>$null
    if ($LASTEXITCODE -ne 0) { $missing += $mod }
}
if ($missing.Count -gt 0) {
    Write-Bad ('缺依赖: ' + ($missing -join ', '))
    Write-Host ''
    Write-Host '    请先执行（只需一次）：' -ForegroundColor Yellow
    Write-Host ('      python -m pip install -r ' + (Join-Path $ScriptsDir 'requirements.txt')) -ForegroundColor Yellow
    Write-Host ''
    exit 1
}
Write-Ok 'fastapi / uvicorn 已就绪'

# --- 3. 关键路径 -----------------------------------------------------
Write-Step '检查登录态与 playwright'
if (Test-Path $ProfileDir) { Write-Ok ("登录态目录存在: " + $ProfileDir) }
else { Write-Bad ("登录态目录不存在: " + $ProfileDir + "  （可能需要本人手动登录一次）") }

if (Test-Path $NodeMods) { Write-Ok ("playwright 目录存在: " + $NodeMods) }
else { Write-Bad ("找不到 node_modules: " + $NodeMods + "  （请修改 MXAI_NODE_MODULES）") }

foreach ($f in @('mxai_adapter.js','mj_run.js','verify_result.js','selftest.js','_deps.js','server.py')) {
    $full = Join-Path $ScriptsDir $f
    if (Test-Path $full) { Write-Ok $f } else { Write-Bad ("缺文件: " + $f) }
}

# --- 4. 环境变量（只作用于本窗口） -----------------------------------
Write-Step '设置环境变量（本窗口有效）'
$env:MXAI_PROFILE      = $ProfileDir
$env:MXAI_NODE_MODULES = $NodeMods
$env:MXAI_ADAPTER_PATH = Join-Path $ScriptsDir 'mxai_adapter.js'
$env:MXAI_URL          = 'https://www.mxai.cn/home/?mp=mjdrawai&from=invite&invite_id=100595351#/mj'
$env:MXAI_HEADLESS     = 'false'
$env:MXAI_PROXY        = '127.0.0.1:7897'
$env:MJ_OUTPUT_DIR     = Join-Path $Root 'output'
$env:MJ_RECEIPTS_DIR   = Join-Path $Root 'receipts'
$env:MJ_ARCHIVE_DIR    = Join-Path $Root 'archive'
$env:MJ_MIN_BYTES      = '200000'
$env:MJ_MIN_DIM        = '1024'
if (-not $env:MJ_BRIDGE_PORT) { $env:MJ_BRIDGE_PORT = '8765' }
# 单次任务超时：本机 MJ 排队实测约 11 分钟，必须给足，否则付费出图会「假失败」
$env:MJ_BRIDGE_TIMEOUT_MS = '1200000'
Write-Ok '环境变量已设置'

# --- 5. 启动 ---------------------------------------------------------
Write-Host ''
Write-Host ('=' * 62)
Write-Host (' 启动服务： http://127.0.0.1:' + $env:MJ_BRIDGE_PORT)
Write-Host (' 健康检查： http://127.0.0.1:' + $env:MJ_BRIDGE_PORT + '/health')
Write-Host (' 台账查看： http://127.0.0.1:' + $env:MJ_BRIDGE_PORT + '/v1/receipts?tail=20')
Write-Host ' 停止服务： 在本窗口按 Ctrl + C'
Write-Host ('=' * 62)
Write-Host ''

Set-Location $ScriptsDir

# 日志落盘：python -u 关掉输出缓冲，无人值守时也能实时看到进度
if ($LogFile) {
    $logDir = Split-Path -Parent $LogFile
    if ($logDir -and -not (Test-Path $logDir)) { New-Item -ItemType Directory -Force -Path $logDir | Out-Null }
    try { Add-Content -Path $LogFile -Value ('[' + (Get-Date -Format 'yyyy-MM-dd HH:mm:ss') + '] starting bridge on port ' + $env:MJ_BRIDGE_PORT) -Encoding UTF8 } catch { }
    # [FIX-20260914-SELFHEAL] 根因就在下面这一行。
    # 本脚本顶部把 $ErrorActionPreference 设成了 'Stop'，而 uvicorn 的启动日志
    # 走 stderr。PowerShell 会把原生命令的 stderr 包装成「终止错误」；在 Stop 下
    # 这会把整条管道当场拆掉，并连带把管道里的 python 一起结束 —— 服务还没
    # 开始监听就没了。这也正是「手动双击能起、自动拉就起不来」的原因：
    #   手动走 else 分支（没有管道），python 不受影响，照样活着；
    #   自动拉走这里（python | Tee），管道一拆 python 就被带走。
    # 修法：只在跑服务这段时间把错误策略放回 'Continue'，跑完恢复原值。
    # 除这一处外，启动逻辑一字未改。
    $prevEap = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        & $pyExe -u server.py 2>&1 | Tee-Object -FilePath $LogFile -Append
    } finally {
        $ErrorActionPreference = $prevEap
    }
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) {
        Write-Bad ('服务进程已退出，退出码 ' + $LASTEXITCODE + '。完整日志：' + $LogFile)
    }
} else {
    & $pyExe -u server.py
}
