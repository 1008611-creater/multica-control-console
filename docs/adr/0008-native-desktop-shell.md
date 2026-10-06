# ADR-0008：桌面产品主程序采用自包含 Windows EXE

- 日期：2026-09-28
- 状态：已采用

## 背景

原有交付物虽然能生成安装器，但用户启动后仍主要面对 `.cmd`、PowerShell 和浏览器页面，无法把它当成一个完整桌面产品使用。

## 决策

新增 `desktop/Multica.Desktop.csproj`，使用 WinForms 生成自包含 `win-x64` 的 `Multica.exe`。桌面程序只负责产品入口和本机运行状态：启动或接管本地桥、展示服务/浏览器/队列状态，并提供打开中文工作台和本地目录的入口。批次提交、登录、付费确认、重提和真实回执仍由中文工作台与用户本人完成。

分发构建先发布桌面 EXE，再复制现有桥源码、运行依赖和空浏览器档案目录，最后生成 ZIP 和 IExpress 安装器。运行数据与用户浏览器档案不进入安装包，也不在升级时清理。

## 影响

- 用户可以双击 `Multica.exe` 使用产品，不需要先理解脚本。
- 安装包体积增加，但目标机器不要求预装 .NET。
- 仍需在另一台 Windows 设备上验证首次安装、代码签名和视觉体验。
- 本决策不改变“不自动登录、不自动付费、不自动发布”的授权边界。


## Bridge lifecycle supplement (2026-10-03)

The bridge remains a local child process because it depends on the Python service, Node/Playwright, and a separate browser process. Embedding these runtimes into the desktop EXE would not remove those dependencies and would make deployment and fault isolation harder. The desktop app starts the bridge, polls health every three seconds, exposes controls for the service process it owns, and attempts at most three recoveries if that process exits unexpectedly.

Automatic recovery starts only the bridge service. It never resumes, retries, or resubmits a generation task. If another process already owns the bridge port, the desktop app only connects and displays status; it does not terminate that process. After three failed recoveries, automatic attempts stop and the user can inspect the installation or start the service manually.

A distributable package should include Python, Node, Playwright packages, and browser runtime files usable on the target machine. The build manifest must reflect actual file checks and must not claim setup is unnecessary when dependencies are missing. Cross-computer support still requires a clean Windows installation test; a successful build on the development computer is not sufficient evidence.

## Bridge stop guard (2026-10-03)

The desktop shell may stop only the bridge process it started, and only after `/control/state` returns the complete expected activity shape and confirms that no batch item is active or awaiting manual review, no job is running, and no batch is running. An HTTP success with missing or malformed state is not proof of idleness: shutdown is blocked. Window close uses the same guard, so an active or unresolved task keeps the bridge available for monitoring and recovery.
