param()
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$target = Join-Path $repo ('tmp/desktop-recovery-contract-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $target | Out-Null
$source = [System.Security.SecurityElement]::Escape((Join-Path $repo 'desktop/Program.cs'))
$emptyFeed = Join-Path $target 'empty-feed'
New-Item -ItemType Directory -Path $emptyFeed | Out-Null
@"
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType><TargetFramework>net10.0-windows</TargetFramework>
    <UseWindowsForms>true</UseWindowsForms><Nullable>enable</Nullable><ImplicitUsings>enable</ImplicitUsings>
    <StartupObject>DesktopRecoveryTests</StartupObject><NuGetAudit>false</NuGetAudit>
    <RestoreSources>$emptyFeed</RestoreSources>
  </PropertyGroup>
  <ItemGroup><Compile Include="$source" Link="Program.cs" />
    <PackageReference Include="Microsoft.Web.WebView2" Version="1.0.2903.40" />
  </ItemGroup>
</Project>
"@ | Set-Content -LiteralPath (Join-Path $target 'RecoveryTests.csproj') -Encoding UTF8
@'
using System.Reflection;
using Microsoft.Web.WebView2.Core;
using Microsoft.Web.WebView2.WinForms;
using Multica.Desktop;
internal static class DesktopRecoveryTests
{
    static int checks;
    static readonly BindingFlags Flags = BindingFlags.Instance | BindingFlags.NonPublic;
    static object? Get(MainForm f, string n) => typeof(MainForm).GetField(n, Flags)!.GetValue(f);
    static void Set(MainForm f, string n, object? v) => typeof(MainForm).GetField(n, Flags)!.SetValue(f, v);
    static void Call(MainForm f, string n, params object[] args) => typeof(MainForm).GetMethod(n, Flags)!.Invoke(f, args);
    static void Check(bool pass, string label) { if (!pass) throw new Exception(label); checks++; Console.WriteLine("PASS " + label); }
    static bool Is(MainForm f, string n) => (bool)Get(f, n)!;
    static WebView2 View(MainForm f) => (WebView2)Get(f, "_workbenchView")!;
    static void Started(MainForm f, WebView2 v, ulong id) => Call(f, "HandleWorkbenchNavigationStarted", v, id);
    static void Completed(MainForm f, WebView2 v, ulong id, bool ok = true, int http = 200) => Call(f, "HandleWorkbenchNavigationCompleted", v, id, ok, http, "test");
    [STAThread]
    static void Main()
    {
        using var f = new MainForm(); // Never Show, CreateControl, EnsureCoreWebView2Async, or contact the bridge.
        var first = View(f);
        var profile = first.CreationProperties.UserDataFolder;
        Check(first.CoreWebView2 is null && !f.IsHandleCreated, "construction does not initialize browser/window");
        Set(f, "_workbenchNavigationPending", true);
        Call(f, "ResetWorkbenchForRetry");
        var current = View(f);
        Check(!ReferenceEquals(first, current) && first.IsDisposed, "hung pending navigation is replaced on retry");
        Check(!Is(f, "_workbenchNavigationPending") && !Is(f, "_workbenchLoadFailed"), "retry unblocks initialization guard");
        Check(current.CreationProperties.UserDataFolder == profile, "retry retains profile path");
        Started(f, current, 10);
        Started(f, current, 11);
        Completed(f, current, 10, false, 500);
        Check(Is(f, "_workbenchNavigationPending") && !Is(f, "_workbenchLoadFailed"), "superseded navigation failure is ignored");
        Completed(f, first, 11);
        Call(f, "HandleWorkbenchProcessFailed", first, CoreWebView2ProcessFailedKind.BrowserProcessExited);
        Check(Is(f, "_workbenchNavigationPending") && !Is(f, "_workbenchLoadFailed"), "disposed view callbacks cannot alter replacement");
        Completed(f, current, 11);
        Check(Is(f, "_workbenchReady") && !Is(f, "_workbenchNavigationPending"), "matching successful navigation becomes ready");
        Call(f, "ResetWorkbenchForRetry");
        Check(ReferenceEquals(current, View(f)), "healthy ready retry preserves page and drafts");
        Call(f, "HandleWorkbenchProcessFailed", current, CoreWebView2ProcessFailedKind.GpuProcessExited);
        Check(Is(f, "_workbenchReady"), "helper process failure preserves healthy page");
        foreach (var kind in new[] { CoreWebView2ProcessFailedKind.BrowserProcessExited, CoreWebView2ProcessFailedKind.RenderProcessExited, CoreWebView2ProcessFailedKind.RenderProcessUnresponsive })
        {
            current = View(f); Set(f, "_workbenchReady", true);
            Call(f, "HandleWorkbenchProcessFailed", current, kind);
            Check(Is(f, "_workbenchLoadFailed") && !Is(f, "_workbenchReady") && !Is(f, "_workbenchNavigationPending"), kind + " exposes failure");
            Check(((Button)Get(f, "_startupRetry")!).Enabled, kind + " enables explicit retry");
            Completed(f, current, 12);
            Check(!Is(f, "_workbenchReady"), kind + " rejects late navigation success");
            Call(f, "ResetWorkbenchForRetry");
            Check(!ReferenceEquals(current, View(f)) && !Is(f, "_workbenchLoadFailed"), kind + " retry recreates control");
        }
        current = View(f); Started(f, current, 20); Completed(f, current, 20, true, 503);
        Check(Is(f, "_workbenchLoadFailed"), "HTTP error cannot count as successful load");
        Call(f, "ResetWorkbenchForRetry"); current = View(f);
        Started(f, current, 21); Call(f, "HandleWorkbenchLoadTimeout");
        Check(Is(f, "_workbenchLoadFailed") && !Is(f, "_workbenchNavigationPending"), "navigation deadline exposes retry");
        Completed(f, current, 21);
        Check(!Is(f, "_workbenchReady"), "late success after timeout is ignored");
        Call(f, "ResetWorkbenchForRetry");
        Set(f, "_workbenchInitializing", true); Call(f, "HandleWorkbenchLoadTimeout");
        Call(f, "ResetWorkbenchForRetry");
        Check(!Is(f, "_workbenchInitializing") && !Is(f, "_workbenchLoadFailed"), "initialization failure can be reset");
        current = View(f); Set(f, "_closing", true); Started(f, current, 30);
        Call(f, "HandleWorkbenchProcessFailed", current, CoreWebView2ProcessFailedKind.RenderProcessExited);
        Call(f, "ResetWorkbenchForRetry");
        Check(ReferenceEquals(current, View(f)) && !Is(f, "_workbenchNavigationPending") && !Is(f, "_workbenchLoadFailed"), "closing ignores recovery events");
        Check(current.CoreWebView2 is null && !f.IsHandleCreated && !current.IsHandleCreated, "all checks finish without browser/window initialization");
        Check(Get(f, "_serverProcess") is null, "checks never start bridge");
        Console.WriteLine($"DESKTOP RECOVERY PASS: {checks} checks; no browser initialization, navigation, HTTP, or production process interaction.");
    }
}
'@ | Set-Content -LiteralPath (Join-Path $target 'RecoveryTests.cs') -Encoding UTF8
& dotnet run --project (Join-Path $target 'RecoveryTests.csproj') --verbosity quiet
if ($LASTEXITCODE -ne 0) { throw 'Desktop recovery contract failed' }
