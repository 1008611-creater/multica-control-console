# Multica 本地抽卡工作台

Windows 本地桌面工作台源码，包含中文桌面入口、FastAPI 抽卡桥、Playwright 浏览器适配器、任务回执、安装脚本和构建脚本。执行渠道为用户自建自动化连接 MXAI 国内 MJ 页面。

## 本地安全边界

- 安装包不包含账号、密码、Cookie 或已登录的浏览器档案。
- 新电脑由使用者本人登录 MXAI；提交付费任务需由使用者当次确认。
- 图片、回执、浏览器档案和运行日志保存在本机，不进入源码仓库。

## Windows 构建

1. 安装 Python 3.10+、Node.js 18+ 和 .NET 10 SDK；Microsoft Edge 用于打开登录浏览器。
2. 双击 `Setup-Multica.cmd` 准备本机 Python 与 Playwright 依赖。
3. 使用 PowerShell 执行 `scripts/build_multica_portable.ps1 -Version 2026-09-28-product` 生成便携包。
4. 执行 `scripts/build_multica_installer.ps1 -Version 2026-09-28-product` 生成安装器。安装器构建还需要 Windows 自带的 IExpress。

构建会写入 `dist/`；源码仓库不保存构建产物、运行时和用户数据。个人配置只能放在未跟踪的 `config/local.ps1`。

## 源码检查

- Node：`node --test mj-automation/scripts/production_machine.test.mjs`
- Python：安装 `mj-automation/scripts/requirements.txt` 后，执行 `python -m unittest discover -s mj-automation/scripts -p test_server_jobs.py`
- Windows PowerShell 脚本通过 `Setup-Multica.cmd`、安装器和桥接启动流程运行。

首次安装和使用说明见 `README_FIRST_RUN.md`。
