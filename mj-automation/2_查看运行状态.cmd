@echo off
chcp 65001 >nul
echo.
echo   MJ 生图桥 - 当前状态
echo   ================================================
echo.
rem [FIX-20260914-SELFHEAL] 状态查询也指向免管理员安装器。
powershell -NoProfile -ExecutionPolicy Bypass -File "E:\codex\multica\mj-automation\scripts\install_autostart_user.ps1" -Status
echo.
echo   ---- 服务健康检查 ----
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $h = Invoke-RestMethod -Uri http://127.0.0.1:8765/health -TimeoutSec 8; Write-Host ('   服务在跑，版本 ' + $h.bridge + '，超时 ' + $h.timeoutMs + ' 毫秒') } catch { Write-Host '   服务没在跑（先跑 3_手动启动桥.cmd）' }"
echo.
pause >nul
