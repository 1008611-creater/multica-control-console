@echo off
chcp 65001 >nul
echo.
echo   MJ 生图桥 - 手动启动（关掉这个窗口 = 停掉服务）
echo   ================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "E:\codex\multica\mj-automation\start_mj_bridge.ps1"
echo.
pause >nul
