param(
  [string]$RootOverride
)
$ErrorActionPreference = 'Stop'
function Fail([string]$Message) {
  Write-Error $Message
  exit 1
}

$root = if ($RootOverride) { (Resolve-Path -LiteralPath $RootOverride).Path } else { Split-Path -Parent $PSScriptRoot }
$required = @(
  'AGENTS.md',
  'CONSTRAINTS.md',
  'PROJECT_CONTEXT.md',
  'docs/INDEX.md',
  'docs/product-spec.md',
  'docs/architecture.md',
  'docs/implementation-plan.md',
  'docs/acceptance.md',
  'scripts/verify.ps1',
  '.gitignore'
)

$missing = @()
foreach ($relative in $required) {
  $path = Join-Path $root $relative
  if (!(Test-Path -LiteralPath $path -PathType Leaf) -or ((Get-Item -LiteralPath $path).Length -eq 0)) {
    $missing += $relative
  }
}
if ($missing.Count -gt 0) {
  Fail ('Missing or empty required files: ' + ($missing -join ', '))
}

$sep = [System.IO.Path]::DirectorySeparatorChar
$altSep = [System.IO.Path]::AltDirectorySeparatorChar
$excludedSegments = @('node_modules', '.venv', 'venv', '__pycache__', '.git', '.cache', 'tmp', 'temp', 'dist', 'build')
$binaryExtensions = @('.png', '.jpg', '.jpeg', '.webp', '.gif', '.ico', '.bmp', '.mp4', '.mov', '.mp3', '.wav', '.zip', '.7z', '.gz', '.pdf', '.dll', '.exe', '.so', '.bin', '.woff', '.woff2', '.ttf', '.otf', '.pyc', '.db', '.sqlite')

function Get-RelativePath([System.IO.FileInfo]$File) {
  return $File.FullName.Substring($root.Length).TrimStart($sep, $altSep).Replace($altSep, $sep)
}
function Test-GovernedPath([System.IO.FileInfo]$File) {
  $relative = Get-RelativePath $File
  foreach ($part in $relative.Split($sep)) {
    if ($excludedSegments -contains $part) { return $false }
  }
  return $true
}
function Test-ScannableText([System.IO.FileInfo]$File) {
  if ($File.Length -eq 0 -or $File.Length -gt 4MB) { return $false }
  if (!(Test-GovernedPath $File)) { return $false }
  if ($binaryExtensions -contains $File.Extension.ToLowerInvariant()) { return $false }
  return $true
}

$scanCandidates = @(Get-ChildItem -LiteralPath $root -Recurse -File -ErrorAction SilentlyContinue)
$scanFiles = @($scanCandidates | Where-Object { Test-ScannableText $_ })
$joined = ($scanFiles | Get-Content -Raw -Encoding UTF8 -ErrorAction SilentlyContinue) -join [Environment]::NewLine

$secretPatterns = @(
  '(?i)api[_-]?key\s*[:=]\s*[''"][A-Za-z0-9_\-]{16,}[''"]',
  '(?i)(access|refresh)[_-]?token\s*[:=]\s*[''"][A-Za-z0-9_\-\.]{16,}[''"]',
  '(?i)-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----',
  '(?i)\b(password|passwd|secret)\s*[:=]\s*[''"][^''"]{8,}[''"]'
)
foreach ($pattern in $secretPatterns) {
  if ($joined -match $pattern) { Fail ('Potential secret pattern detected: ' + $pattern) }
}

$markdownFiles = @($scanCandidates | Where-Object { (Test-GovernedPath $_) -and ($_.Extension.ToLowerInvariant() -eq '.md') })
if ($markdownFiles.Count -eq 0) { Fail 'No Markdown files found under the workspace' }
$fencePattern = '^\s{0,3}' + ([string][char]96 * 3)
foreach ($file in $markdownFiles) {
  $relative = Get-RelativePath $file
  $lines = @(Get-Content -LiteralPath $file.FullName -Encoding UTF8 -ErrorAction SilentlyContinue)
  if ($lines.Count -eq 0) { Fail ('Markdown file is empty: ' + $relative) }
  if (@($lines | Where-Object { $_ -match '^#{1,6}\s+\S' }).Count -eq 0) { Fail ('Markdown file has no ATX heading: ' + $relative) }
  $fences = @($lines | Where-Object { $_ -match $fencePattern }).Count
  if ($fences % 2 -ne 0) { Fail ('Markdown code fences are unbalanced (' + $fences + '): ' + $relative) }
  $fileDir = Split-Path -Parent $file.FullName
  $raw = Get-Content -Raw -Encoding UTF8 $file.FullName -ErrorAction SilentlyContinue
  foreach ($link in [regex]::Matches($raw, '\]\((\.\.?/[^)\s]+)\)')) {
    $target = $link.Groups[1].Value.Split('#')[0]
    if ($target -eq '') { continue }
    if (!(Test-Path -LiteralPath (Join-Path $fileDir $target))) {
      Fail ('Markdown relative link is broken: ' + $relative + ' -> ' + $target)
    }
  }
}

# ---- PowerShell encoding: non-ASCII scripts must carry a UTF-8 BOM ----
# Windows PowerShell 5.1 reads BOM-less scripts as ANSI, which corrupts non-ASCII
# literals and paths. Keeping this check here stops that failure class from returning.
$ps1Files = @($scanCandidates | Where-Object { (Test-GovernedPath $_) -and ($_.Extension.ToLowerInvariant() -eq '.ps1') })
foreach ($file in $ps1Files) {
  $bytes = [System.IO.File]::ReadAllBytes($file.FullName)
  if ($bytes.Length -eq 0) { continue }
  $hasBom = ($bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF)
  $hasNonAscii = $false
  foreach ($byte in $bytes) { if ($byte -gt 0x7F) { $hasNonAscii = $true; break } }
  if ($hasNonAscii -and !$hasBom) { Fail ('PowerShell script has non-ASCII text but no UTF-8 BOM: ' + (Get-RelativePath $file)) }
}

Write-Output 'VERIFY PASS: required files, secret patterns, Markdown structure, reference-integrity, and script-encoding checks succeeded.'
