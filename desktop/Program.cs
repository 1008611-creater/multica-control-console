using System.Diagnostics;
using System.Net.Http.Json;
using System.Text.Json;
using System.Drawing.Drawing2D;

namespace Multica.Desktop;

internal static class Program
{
    [STAThread]
    private static void Main()
    {
        ApplicationConfiguration.Initialize();
        Application.Run(new MainForm());
    }
}

internal sealed class MainForm : Form
{
    private readonly HttpClient _http = new() { Timeout = TimeSpan.FromSeconds(4) };
    private readonly System.Windows.Forms.Timer _timer = new() { Interval = 3000 };
    private readonly Label _serviceValue = new();
    private readonly Label _browserValue = new();
    private readonly Label _queueValue = new();
    private readonly Label _detailValue = new();
    private readonly Label _lastAction = new();
    private readonly Panel _serviceDot = new();
    private readonly Panel _browserDot = new();
    private readonly Panel _queueDot = new();
    private readonly Button _openWorkbench = new();
    private readonly Button _browserButton = new();
    private readonly Button _stopButton = new();
    private Process? _serverProcess;
    private bool _closing;
    private readonly string _root;
    private readonly string _baseUrl;

    private static readonly Color Bg = Color.FromArgb(13, 17, 23);
    private static readonly Color Panel = Color.FromArgb(22, 29, 38);
    private static readonly Color Panel2 = Color.FromArgb(28, 37, 48);
    private static readonly Color Line = Color.FromArgb(50, 62, 76);
    private static readonly Color TextColor = Color.FromArgb(237, 241, 245);
    private static readonly Color Muted = Color.FromArgb(153, 166, 180);
    private static readonly Color Accent = Color.FromArgb(201, 239, 120);
    private static readonly Color Good = Color.FromArgb(143, 224, 176);
    private static readonly Color Warn = Color.FromArgb(243, 202, 125);
    private static readonly Color Bad = Color.FromArgb(255, 147, 140);

    public MainForm()
    {
        _root = AppContext.BaseDirectory.TrimEnd(Path.DirectorySeparatorChar);
        var port = Environment.GetEnvironmentVariable("MULTICA_PORT") ?? "8765";
        _baseUrl = $"http://127.0.0.1:{port}";
        this.Text = "Multica 本地抽卡工作台";
        StartPosition = FormStartPosition.CenterScreen;
        MinimumSize = new Size(980, 660);
        ClientSize = new Size(1120, 720);
        BackColor = Bg;
        ForeColor = TextColor;
        Font = new Font("Microsoft YaHei UI", 10F);
        FormBorderStyle = FormBorderStyle.Sizable;
        DoubleBuffered = true;
        BuildUi();
        _timer.Tick += async (_, _) => await RefreshStatusAsync();
        Shown += async (_, _) =>
        {
            SetAction("正在启动本地工作台…");
            await StartServiceAsync();
            await RefreshStatusAsync();
        };
        FormClosing += (_, _) =>
        {
            if (_closing) return;
            _closing = true;
            _timer.Stop();
            StopOwnedServer();
        };
    }

    private void BuildUi()
    {
        var root = new TableLayoutPanel { Dock = DockStyle.Fill, ColumnCount = 2, RowCount = 1, BackColor = Bg };
        root.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 246));
        root.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100));
        Controls.Add(root);

        var side = new Panel { Dock = DockStyle.Fill, Padding = new Padding(22, 26, 18, 22), BackColor = Color.FromArgb(17, 22, 29) };
        root.Controls.Add(side, 0, 0);
        var brand = new Label { Text = "M", AutoSize = false, Size = new Size(42, 42), BackColor = Accent, ForeColor = Color.FromArgb(28, 39, 18), Font = new Font("Segoe UI", 23, FontStyle.Bold), TextAlign = ContentAlignment.MiddleCenter };
        brand.Paint += (_, e) => e.Graphics.SmoothingMode = SmoothingMode.AntiAlias;
        side.Controls.Add(brand);
        var title = NewLabel("Multica", 21, FontStyle.Bold, TextColor); title.Location = new Point(76, 25); title.AutoSize = true; side.Controls.Add(title);
        var subtitle = NewLabel("本地抽卡工作台", 10, FontStyle.Regular, Muted); subtitle.Location = new Point(77, 57); subtitle.AutoSize = true; side.Controls.Add(subtitle);
        var version = NewLabel("Windows 产品版  ·  v1.0", 9, FontStyle.Regular, Muted); version.Location = new Point(22, 91); version.AutoSize = true; side.Controls.Add(version);

        var nav = new FlowLayoutPanel { FlowDirection = FlowDirection.TopDown, WrapContents = false, Dock = DockStyle.Top, Location = new Point(16, 135), Size = new Size(206, 280), BackColor = Color.Transparent, Padding = new Padding(0, 14, 0, 0) };
        side.Controls.Add(nav);
        nav.Controls.Add(MakeNavButton("⌂   工作台", OpenWorkbench));
        nav.Controls.Add(MakeNavButton("◉   打开登录浏览器", () => _ = StartBrowser()));
        nav.Controls.Add(MakeNavButton("▣   打开成品目录", OpenOutput));
        nav.Controls.Add(MakeNavButton("⚙   打开安装目录", OpenRoot));
        nav.Controls.Add(MakeNavButton("■   停止本地服务", StopService));
        var hint = NewLabel("所有真实提交都在工作台内再次确认。\n本程序不会读取或显示密码、Cookie、Token。", 9, FontStyle.Regular, Muted);
        hint.AutoSize = false; hint.Size = new Size(198, 60); hint.Location = new Point(22, 515); side.Controls.Add(hint);
        var copyright = NewLabel("Multica Local Studio", 9, FontStyle.Regular, Color.FromArgb(109, 121, 135)); copyright.AutoSize = true; copyright.Location = new Point(22, 650); side.Controls.Add(copyright);

        var content = new Panel { Dock = DockStyle.Fill, Padding = new Padding(30, 26, 30, 24), BackColor = Bg, AutoScroll = true };
        root.Controls.Add(content, 1, 0);
        var header = new Panel { Dock = DockStyle.Top, Height = 88, BackColor = Color.Transparent };
        content.Controls.Add(header);
        var h1 = NewLabel("欢迎使用 Multica", 26, FontStyle.Bold, TextColor); h1.Location = new Point(0, 0); h1.AutoSize = true; header.Controls.Add(h1);
        var h2 = NewLabel("在一个清楚的窗口里管理批次、浏览器和真实回执。", 11, FontStyle.Regular, Muted); h2.Location = new Point(2, 43); h2.AutoSize = true; header.Controls.Add(h2);
        _detailValue.Text = "正在检查本机状态…"; _detailValue.ForeColor = Muted; _detailValue.AutoSize = false; _detailValue.TextAlign = ContentAlignment.MiddleRight; _detailValue.Dock = DockStyle.Right; _detailValue.Width = 300; header.Controls.Add(_detailValue);

        var statusGrid = new TableLayoutPanel { Dock = DockStyle.Top, Height = 152, ColumnCount = 3, RowCount = 1, BackColor = Color.Transparent, Padding = new Padding(0, 0, 0, 18) };
        statusGrid.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 33.33f)); statusGrid.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 33.33f)); statusGrid.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 33.33f));
        content.Controls.Add(statusGrid);
        statusGrid.Controls.Add(MakeStatusCard("本地服务", "正在检查", _serviceValue, _serviceDot), 0, 0);
        statusGrid.Controls.Add(MakeStatusCard("可见浏览器", "未启动", _browserValue, _browserDot), 1, 0);
        statusGrid.Controls.Add(MakeStatusCard("任务队列", "等待读取", _queueValue, _queueDot), 2, 0);

        var actionCard = MakeCard(); actionCard.Dock = DockStyle.Top; actionCard.Height = 186; actionCard.Padding = new Padding(20); content.Controls.Add(actionCard);
        var actionTitle = NewLabel("开始工作", 16, FontStyle.Bold, TextColor); actionTitle.Location = new Point(20, 16); actionTitle.AutoSize = true; actionCard.Controls.Add(actionTitle);
        var actionSub = NewLabel("先打开工作台查看批次队列；需要登录时，再打开可见浏览器完成登录。", 10, FontStyle.Regular, Muted); actionSub.Location = new Point(20, 48); actionSub.AutoSize = true; actionCard.Controls.Add(actionSub);
        _openWorkbench.Text = "打开中文工作台"; StyleButton(_openWorkbench, true); _openWorkbench.Location = new Point(20, 88); _openWorkbench.Size = new Size(190, 44); _openWorkbench.Click += (_, _) => OpenWorkbench(); actionCard.Controls.Add(_openWorkbench);
        _browserButton.Text = "打开登录浏览器"; StyleButton(_browserButton, false); _browserButton.Location = new Point(224, 88); _browserButton.Size = new Size(170, 44); _browserButton.Click += async (_, _) => await StartBrowser(); actionCard.Controls.Add(_browserButton);
        _stopButton.Text = "停止服务"; StyleButton(_stopButton, false); _stopButton.Location = new Point(408, 88); _stopButton.Size = new Size(130, 44); _stopButton.Click += (_, _) => StopService(); actionCard.Controls.Add(_stopButton);
        var note = NewLabel("安全提示：登录、付费提交和重提都必须由你在工作台里明确确认。", 10, FontStyle.Regular, Warn); note.Location = new Point(20, 145); note.AutoSize = true; actionCard.Controls.Add(note);

        var logCard = MakeCard(); logCard.Dock = DockStyle.Top; logCard.Height = 176; logCard.Padding = new Padding(20); logCard.Margin = new Padding(0, 16, 0, 0); content.Controls.Add(logCard);
        var logTitle = NewLabel("运行记录", 16, FontStyle.Bold, TextColor); logTitle.Location = new Point(20, 16); logTitle.AutoSize = true; logCard.Controls.Add(logTitle);
        _lastAction.Text = "等待操作"; _lastAction.ForeColor = Muted; _lastAction.AutoSize = false; _lastAction.Location = new Point(20, 53); _lastAction.Size = new Size(700, 74); _lastAction.Anchor = AnchorStyles.Left | AnchorStyles.Top | AnchorStyles.Right; logCard.Controls.Add(_lastAction);
        var path = NewLabel("数据、回执和成品始终保存在当前安装目录，不会因关闭窗口自动清理。", 9, FontStyle.Regular, Muted); path.Location = new Point(20, 136); path.AutoSize = true; logCard.Controls.Add(path);
    }

    private static Label NewLabel(string text, float size, FontStyle style, Color color) => new() { Text = text, Font = new Font("Microsoft YaHei UI", size, style), ForeColor = color, BackColor = Color.Transparent };
    private static Panel MakeCard() => new() { BackColor = Panel, BorderStyle = BorderStyle.FixedSingle, Margin = new Padding(0, 0, 10, 0) };

    private Panel MakeStatusCard(string title, string value, Label valueLabel, Panel dot)
    {
        var card = MakeCard(); card.Dock = DockStyle.Fill; card.Margin = new Padding(0, 0, 10, 0); card.Padding = new Padding(17);
        var label = NewLabel(title, 10, FontStyle.Regular, Muted); label.Location = new Point(17, 16); label.AutoSize = true; card.Controls.Add(label);
        dot.Size = new Size(9, 9); dot.Location = new Point(17, 54); dot.BackColor = Warn; card.Controls.Add(dot);
        valueLabel.Text = value; valueLabel.Font = new Font("Microsoft YaHei UI", 14, FontStyle.Bold); valueLabel.ForeColor = TextColor; valueLabel.AutoSize = false; valueLabel.Location = new Point(34, 46); valueLabel.Size = new Size(180, 28); card.Controls.Add(valueLabel);
        return card;
    }

    private Button MakeNavButton(string text, Action action)
    {
        var b = new Button { Text = text, Width = 206, Height = 42, TextAlign = ContentAlignment.MiddleLeft, FlatStyle = FlatStyle.Flat, BackColor = Color.Transparent, ForeColor = TextColor, Font = new Font("Microsoft YaHei UI", 10), Margin = new Padding(0, 3, 0, 3), Padding = new Padding(12, 0, 0, 0) };
        b.FlatAppearance.BorderSize = 0; b.FlatAppearance.MouseOverBackColor = Panel2; b.Click += (_, _) => action(); return b;
    }

    private static void StyleButton(Button button, bool primary)
    {
        button.FlatStyle = FlatStyle.Flat; button.FlatAppearance.BorderSize = 1; button.FlatAppearance.BorderColor = primary ? Accent : Line; button.BackColor = primary ? Accent : Panel2; button.ForeColor = primary ? Color.FromArgb(27, 39, 15) : TextColor; button.Font = new Font("Microsoft YaHei UI", 10, FontStyle.Bold); button.Cursor = Cursors.Hand;
    }

    private async Task StartServiceAsync()
    {
        if (await IsHealthyAsync()) { SetAction("本地服务已经在运行，已接管现有工作台。"); _timer.Start(); return; }
        var python = FindPython();
        var script = Path.Combine(_root, "mj-automation", "scripts", "server.py");
        if (python is null || !File.Exists(script)) { SetAction("缺少内置运行环境。请重新安装完整版本，不会自动下载依赖。", true); return; }
        var scripts = Path.Combine(_root, "mj-automation", "scripts");
        var run = Path.Combine(_root, "mj-automation", "run");
        var output = Path.Combine(_root, "mj-automation", "output");
        var jobs = Path.Combine(run, "jobs"); var receipts = Path.Combine(_root, "mj-automation", "receipts"); var archive = Path.Combine(_root, "mj-automation", "archive");
        foreach (var d in new[] { run, output, jobs, receipts, archive, Path.Combine(_root, "runtime", "browser-profile") }) Directory.CreateDirectory(d);
        var psi = new ProcessStartInfo(python, "server.py") { WorkingDirectory = scripts, UseShellExecute = false, CreateNoWindow = true, RedirectStandardOutput = true, RedirectStandardError = true };
        psi.Environment["MJ_BRIDGE_PORT"] = Environment.GetEnvironmentVariable("MULTICA_PORT") ?? "8765";
        psi.Environment["MJ_OUTPUT_DIR"] = output; psi.Environment["MJ_JOBS_DIR"] = jobs; psi.Environment["MJ_RECEIPTS_DIR"] = receipts; psi.Environment["MJ_ARCHIVE_DIR"] = archive;
        psi.Environment["MXAI_PROFILE"] = Path.Combine(_root, "runtime", "browser-profile"); psi.Environment["MXAI_NODE_MODULES"] = Path.Combine(_root, "runtime", "node_modules"); psi.Environment["MXAI_ADAPTER_PATH"] = Path.Combine(scripts, "mxai_adapter.js"); psi.Environment["MJ_PYTHON"] = python;
        try { _serverProcess = Process.Start(psi); } catch (Exception ex) { SetAction("本地服务启动失败：" + ex.Message, true); return; }
        if (_serverProcess is not null) _serverProcess.BeginOutputReadLine();
        for (var i = 0; i < 40; i++) { await Task.Delay(500); if (await IsHealthyAsync()) { SetAction("本地服务已启动，可以打开中文工作台。"); _timer.Start(); return; } }
        SetAction("本地服务启动超时，请查看安装目录中的运行记录。", true);
    }

    private string? FindPython()
    {
        var candidates = new[] { Path.Combine(_root, "runtime", "python", "python.exe"), Path.Combine(_root, "runtime", "python", "Scripts", "python.exe") };
        return candidates.FirstOrDefault(File.Exists);
    }

    private async Task<bool> IsHealthyAsync()
    {
        try { using var response = await _http.GetAsync(_baseUrl + "/health"); return response.IsSuccessStatusCode; } catch { return false; }
    }

    private async Task RefreshStatusAsync()
    {
        try
        {
            var state = await _http.GetFromJsonAsync<JsonElement>(_baseUrl + "/control/state");
            var health = state.TryGetProperty("health", out var h) && h.TryGetProperty("ok", out var ok) && ok.GetBoolean();
            var browser = state.TryGetProperty("browser", out var br) && br.TryGetProperty("running", out var running) && running.GetBoolean();
            var logged = br.ValueKind == JsonValueKind.Object && br.TryGetProperty("loggedIn", out var li) && li.GetBoolean();
            var jobs = state.TryGetProperty("jobs", out var j) && j.TryGetProperty("items", out var items) ? items.GetArrayLength() : 0;
            var receipts = state.TryGetProperty("receipts", out var r) && r.TryGetProperty("items", out var ri) ? ri.GetArrayLength() : 0;
            SetStatus(_serviceValue, _serviceDot, health ? "已连接" : "不可用", health ? Good : Bad);
            SetStatus(_browserValue, _browserDot, !browser ? "未启动" : logged ? "已登录" : "已启动，未登录", !browser ? Warn : logged ? Good : Warn);
            SetStatus(_queueValue, _queueDot, jobs == 0 ? "暂无作业" : $"{jobs} 个作业", jobs == 0 ? Muted : Good);
            _detailValue.Text = $"作业 {jobs} · 回执 {receipts} · 每 3 秒更新";
            _openWorkbench.Enabled = health; _browserButton.Enabled = health; _stopButton.Enabled = health;
        }
        catch { SetStatus(_serviceValue, _serviceDot, "不可用", Bad); _detailValue.Text = "无法读取本机状态"; _openWorkbench.Enabled = false; _browserButton.Enabled = false; }
    }

    private static void SetStatus(Label value, Panel dot, string text, Color color) { value.Text = text; value.ForeColor = color == Bad ? Bad : TextColor; dot.BackColor = color; }
    private void SetAction(string text, bool bad = false) { if (IsDisposed) return; _lastAction.Text = $"{DateTime.Now:HH:mm:ss}  {text}"; _lastAction.ForeColor = bad ? Bad : Muted; }
    private void OpenWorkbench() { try { Process.Start(new ProcessStartInfo(_baseUrl + "/control") { UseShellExecute = true }); SetAction("已打开中文工作台。"); } catch (Exception ex) { SetAction("打开工作台失败：" + ex.Message, true); } }
    private void OpenOutput() => OpenFolder(Path.Combine(_root, "mj-automation", "output"), "成品目录");
    private void OpenRoot() => OpenFolder(_root, "安装目录");
    private void OpenFolder(string path, string label) { try { Directory.CreateDirectory(path); Process.Start(new ProcessStartInfo("explorer.exe", $"\"{path}\"") { UseShellExecute = true }); SetAction("已打开" + label + "。"); } catch (Exception ex) { SetAction("打开" + label + "失败：" + ex.Message, true); } }
    private async Task StartBrowser() { try { var response = await _http.PostAsync(_baseUrl + "/control/browser/start", null); var msg = await response.Content.ReadAsStringAsync(); SetAction(response.IsSuccessStatusCode ? "可见登录浏览器已打开，请你本人完成登录。" : "打开浏览器失败：" + msg, !response.IsSuccessStatusCode); await RefreshStatusAsync(); } catch (Exception ex) { SetAction("打开浏览器失败：" + ex.Message, true); } }
    private void StopService() { StopOwnedServer(); SetAction("已停止本程序启动的本地服务。"); _timer.Stop(); SetStatus(_serviceValue, _serviceDot, "已停止", Warn); }
    private void StopOwnedServer() { try { if (_serverProcess is { HasExited: false }) _serverProcess.Kill(entireProcessTree: true); } catch { } finally { _serverProcess = null; } }
}
