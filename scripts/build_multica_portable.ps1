[CmdletBinding()]
param([string]$Version = '2026-09-28-product')
$ErrorActionPreference = 'Stop'
$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$DistRoot = Join-Path $RepoRoot 'dist'
$PackageName = 'Multica-Control-Console-' + $Version
$PackageRoot = Join-Path $DistRoot $PackageName
$ZipPath = Join-Path $DistRoot ($PackageName + '.zip')
$DesktopProject = Join-Path $RepoRoot 'desktop\Multica.Desktop.csproj'
$DesktopPublishRoot = Join-Path $env:TEMP ('Multica-Desktop-Publish-' + $Version + '-' + [guid]::NewGuid().ToString('N'))
if (-not (Test-Path -LiteralPath $DesktopProject)) { throw '缺少桌面主程序项目：desktop\Multica.Desktop.csproj' }
$dotnet = Get-Command dotnet.exe -ErrorAction SilentlyContinue
if (-not $dotnet) { throw '构建桌面 EXE 需要 .NET SDK。' }
if (-not (Test-Path -LiteralPath $DistRoot)) { New-Item -ItemType Directory -Force -Path $DistRoot | Out-Null }
$distResolved = (Resolve-Path -LiteralPath $DistRoot).Path
if (Test-Path -LiteralPath $PackageRoot) {
  $candidate = (Resolve-Path -LiteralPath $PackageRoot).Path
  if (-not $candidate.StartsWith($distResolved + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'Refusing to remove a path outside dist.' }
  Remove-Item -LiteralPath $candidate -Recurse -Force
}
if (Test-Path -LiteralPath $ZipPath) { Remove-Item -LiteralPath $ZipPath -Force }
New-Item -ItemType Directory -Force -Path $PackageRoot | Out-Null
& $dotnet.Source publish $DesktopProject --configuration Release --runtime win-x64 --self-contained true --output $DesktopPublishRoot -p:PublishSingleFile=true -p:IncludeNativeLibrariesForSelfExtract=true -p:EnableCompressionInSingleFile=true --nologo
if ($LASTEXITCODE -ne 0) { throw ('桌面 EXE 构建失败：' + $LASTEXITCODE) }
New-Item -ItemType Directory -Force -Path $PackageRoot | Out-Null
Copy-Item -LiteralPath (Join-Path $DesktopPublishRoot 'Multica.exe') -Destination (Join-Path $PackageRoot 'Multica.exe') -Force
function Copy-Required([string]$Source, [string]$Destination) {
  if (-not (Test-Path -LiteralPath $Source)) { throw ('Missing required source: ' + $Source) }
  $parent = Split-Path -Parent $Destination
  if ($parent) { New-Item -ItemType Directory -Force -Path $parent | Out-Null }
  Copy-Item -LiteralPath $Source -Destination $Destination -Recurse -Force
}
Copy-Required (Join-Path $RepoRoot 'mj-automation\scripts') (Join-Path $PackageRoot 'mj-automation\scripts')
Copy-Required (Join-Path $RepoRoot 'mj-automation\start_mj_bridge.ps1') (Join-Path $PackageRoot 'mj-automation\start_mj_bridge.ps1')
$profileLeak = Join-Path $PackageRoot 'mj-automation\scripts\.browser-profile'
if (Test-Path -LiteralPath $profileLeak) {
  $resolvedLeak = (Resolve-Path -LiteralPath $profileLeak).Path
  if (-not $resolvedLeak.StartsWith((Join-Path $PackageRoot 'mj-automation\scripts') + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) { throw 'Refusing to remove a path outside the package scripts directory.' }
  Remove-Item -LiteralPath $resolvedLeak -Recurse -Force
}
Copy-Required (Join-Path $RepoRoot 'mj-automation\control') (Join-Path $PackageRoot 'mj-automation\control')
foreach ($relative in @('Install-Multica.cmd','Setup-Multica.cmd','Start-Multica.cmd','Stop-Multica.cmd','Open-Control.cmd','README_FIRST_RUN.md')) {
  Copy-Required (Join-Path $RepoRoot $relative) (Join-Path $PackageRoot $relative)
}
Copy-Required (Join-Path $RepoRoot 'config\local.ps1.example') (Join-Path $PackageRoot 'config\local.ps1.example')
$runtime = Join-Path $PackageRoot 'runtime'
$browserProfile = Join-Path $runtime 'browser-profile'
$nodeModules = Join-Path $runtime 'node_modules'
New-Item -ItemType Directory -Force -Path $browserProfile, $nodeModules | Out-Null
Set-Content -LiteralPath (Join-Path $browserProfile 'README.txt') -Value "此目录在分发包中为空；本机档案会在用户手动登录后创建。请勿分享此目录。" -Encoding UTF8
$legacyNodeModules = 'E:\codex\niannianai\zhuanhuiyuangong\ai-rpa-console\node_modules'
$sourceNodeModules = Join-Path $RepoRoot 'runtime\node_modules'
if (-not (Test-Path -LiteralPath (Join-Path $sourceNodeModules 'playwright\package.json'))) {
  if (Test-Path -LiteralPath $legacyNodeModules) { $sourceNodeModules = $legacyNodeModules }
}
if (Test-Path -LiteralPath (Join-Path $sourceNodeModules 'playwright\package.json')) {
  Copy-Item -Path (Join-Path $sourceNodeModules '*') -Destination $nodeModules -Recurse -Force
}
$bundledPythonHome = if ($env:MULTICA_PYTHON_HOME) { $env:MULTICA_PYTHON_HOME } else { 'C:\Users\lsb\AppData\Roaming\uv\python\cpython-3.11-windows-x86_64-none' }
$bundledPythonExe = Join-Path $bundledPythonHome 'python.exe'
$bundledPythonTarget = Join-Path $runtime 'python'
if (Test-Path -LiteralPath $bundledPythonExe) {
  New-Item -ItemType Directory -Force -Path $bundledPythonTarget | Out-Null
  Copy-Item -Path (Join-Path $bundledPythonHome '*') -Destination $bundledPythonTarget -Recurse -Force
  $bundledSitePackages = Join-Path $bundledPythonTarget 'Lib\site-packages'
  if (Test-Path -LiteralPath $bundledSitePackages) { Remove-Item -LiteralPath $bundledSitePackages -Recurse -Force }
  New-Item -ItemType Directory -Force -Path $bundledSitePackages | Out-Null
  $sitePackagesSource = Join-Path $RepoRoot 'runtime\python\Lib\site-packages'
  $sitePackagesTarget = Join-Path $bundledPythonTarget 'Lib\site-packages'
  if (Test-Path -LiteralPath $sitePackagesSource) {
    New-Item -ItemType Directory -Force -Path $sitePackagesTarget | Out-Null
    Copy-Item -Path (Join-Path $sitePackagesSource '*') -Destination $sitePackagesTarget -Recurse -Force
  }
}
$bundledNodeTarget = Join-Path $runtime 'node'
$bundledNodeSource = if ($env:MULTICA_NODE_EXE) { $env:MULTICA_NODE_EXE } else { 'C:\Program Files\nodejs\node.exe' }
if (Test-Path -LiteralPath $bundledNodeSource) {
  New-Item -ItemType Directory -Force -Path $bundledNodeTarget | Out-Null
  Copy-Item -LiteralPath $bundledNodeSource -Destination (Join-Path $bundledNodeTarget 'node.exe') -Force
}
Set-Content -LiteralPath (Join-Path $runtime 'README.md') -Value "未随包提供的运行依赖会由 Setup-Multica.cmd 安装。" -Encoding UTF8
$generatedDirs = @('mj-automation\output','mj-automation\archive','mj-automation\receipts','mj-automation\run\jobs','mj-automation\run\logs')
foreach ($relative in $generatedDirs) { New-Item -ItemType Directory -Force -Path (Join-Path $PackageRoot $relative) | Out-Null }
$manifest = [ordered]@{
  package = $PackageName
  generatedAt = (Get-Date).ToUniversalTime().ToString('o')
  entrypoints = @('Multica.exe','Install-Multica.cmd','Setup-Multica.cmd','Start-Multica.cmd','Stop-Multica.cmd','Open-Control.cmd')
  desktopAppBundled = (Test-Path -LiteralPath (Join-Path $PackageRoot 'Multica.exe'))
  controlUrl = 'http://127.0.0.1:8765/control'
  includesBrowserProfile = $false
  includesCredentials = $false
  includesGeneratedMedia = $false
  sourceNodeModulesBundled = (Test-Path -LiteralPath (Join-Path $nodeModules 'playwright\package.json'))
  bundledPython = (Test-Path -LiteralPath (Join-Path $runtime 'python\python.exe'))
  bundledNode = (Test-Path -LiteralPath (Join-Path $runtime 'node\node.exe'))
  setupRequiredOnTargetMachine = $false
}
$manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $PackageRoot 'PACKAGE_MANIFEST.json') -Encoding UTF8
Compress-Archive -LiteralPath $PackageRoot -DestinationPath $ZipPath -CompressionLevel Optimal
$zip = Get-Item -LiteralPath $ZipPath
Write-Output ('BUILD OK: ' + $PackageRoot)
Write-Output ('ZIP: ' + $ZipPath + ' (' + [math]::Round($zip.Length / 1MB, 1) + ' MB)')









