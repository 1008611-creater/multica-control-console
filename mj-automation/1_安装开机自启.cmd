@echo off
chcp 65001 >nul

echo.
echo   MJ 生图桥 - 安装「开机自启 + 掉线自愈」
echo   ================================================
echo.
echo   这一版不需要管理员权限，不会弹 UAC 窗口。
echo   装好后：开机自动拉起桥，掉线 5 分钟内自动恢复。
echo   在下面这个窗口里看结果，看完关掉即可。
echo.
rem [FIX-20260914-SELFHEAL] 改用免管理员安装器（写登录启动项），不再弹 UAC。
powershell -NoProfile -ExecutionPolicy Bypass -NoExit -File "E:\codex\multica\mj-automation\scripts\install_autostart_user.ps1"

echo   已发起安装。按任意键关闭本窗口。
pause >nul
