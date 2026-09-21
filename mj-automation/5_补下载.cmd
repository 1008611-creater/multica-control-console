@echo off
chcp 65001 >nul
setlocal
echo.
echo   MJ 生图桥 - 补下载已出好的图（免费，不重跑、不扣积分）
echo   ================================================
echo.
echo   用途：站点那边已经出好图、但我们没取回来时，用这个把图补下来。
echo   不会重新生成、不会消耗积分。
echo.
echo   序列号在哪儿看：出图记录里那条任务的 serial 号（一串长数字）。
echo.
set /p SERIAL=  请粘贴序列号，然后回车: 
if "%SERIAL%"=="" (
  echo.
  echo   没有填序列号，已取消。
  pause >nul
  exit /b 1
)
echo.
set /p PREFIX=  给它起个文件名（可留空，直接回车用默认）: 
echo.
echo   正在补下载，请稍等（一般 1 分钟内，站点慢时可能更久）...
echo.
powershell -NoProfile -ExecutionPolicy Bypass -Command "$ErrorActionPreference='Stop'; try { $body = @{ mode='dl-serial'; serial='%SERIAL%'; prefix='%PREFIX%' } | ConvertTo-Json; $r = Invoke-RestMethod -Uri http://127.0.0.1:8765/v1/maintenance -Method Post -ContentType 'application/json' -Body $body -TimeoutSec 600; Write-Host ('   结果: ' + $r.status); if ($r.file) { Write-Host ('   文件: ' + $r.file) }; if ($r.w) { Write-Host ('   尺寸: ' + $r.w + 'x' + $r.h + '  ' + $r.bytes + ' 字节') }; if ($r.cached) { Write-Host '   （本地已有，直接复用，没走浏览器）' }; if (-not $r.ok) { Write-Host ('   说明: ' + $r.error) } } catch { Write-Host ('   失败: ' + $_.Exception.Message); Write-Host '   先确认桥在跑（双击 2_查看运行状态.cmd）。' }"
echo.
pause >nul
