@echo off
chcp 65001 >nul
echo.
echo   MJ 生图桥 - 出图前自检（只检查，不出图、不扣积分）
echo   ================================================
echo.
powershell -NoProfile -ExecutionPolicy Bypass -File "E:\codex\multica\mj-automation\scripts\preflight_check.ps1"
echo.
pause >nul
