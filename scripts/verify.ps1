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
  'README.md',
  'docs/INDEX.md',
  'projects/README.md',
  'docs/product-spec.md',
  'docs/architecture.md',
  'docs/lifecycle.md',
  'docs/implementation-plan.md',
  'docs/acceptance.md',
  'docs/release-checklist.md',
  'docs/retro-template.md',
  'docs/project-state-contract.md',
  'docs/task-templates/README.md',
  'docs/task-templates/content-production.md',
  'docs/task-templates/review-and-release.md',
  'docs/task-templates/data-review.md',
  'docs/task-templates/autopilot.md',
  'docs/task-templates/project-state-audit.md',
  'docs/task-templates/multica-pilot-project-audit.md',
  'docs/task-templates/stage-map.md',
  'docs/adr/0001-workspace-governance.md',
  'docs/adr/0002-project-template-layer.md',
  '.gitignore',
  '.gitattributes',
  'templates/README.md',
  'templates/project-template/AGENTS.md',
  'templates/project-template/CONSTRAINTS.md',
  'templates/project-template/PROJECT_CONTEXT.md',
  'templates/project-template/docs/INDEX.md',
  'templates/project-template/docs/product-spec.md',
  'templates/project-template/docs/architecture.md',
  'templates/project-template/docs/implementation-plan.md',
  'templates/project-template/docs/acceptance.md',
  'templates/project-template/scripts/verify.ps1',
  'templates/project-template/.github/workflows/ci.yml',
  'templates/project-template/.gitignore',
  'skills/README.md'
)

$missing = @()
foreach ($relative in $required) {
  $path = Join-Path $root $relative
  if (!(Test-Path -LiteralPath $path -PathType Leaf) -or ((Get-Item -LiteralPath $path).Length -eq 0)) {
    $missing += $relative
  }
}
if ($missing.Count -gt 0) {
  Fail "Missing or empty required files: $($missing -join ', ')"
}

$stateFiles = @(Get-ChildItem -LiteralPath (Join-Path $root 'projects') -Recurse -File -Filter 'project_state.yaml' |
  Where-Object { $_.FullName -notmatch '\\(node_modules|\.git)\\' })
if ($stateFiles.Count -eq 0) { Fail 'No project_state.yaml found under projects/' }
$inventoryPath = Join-Path $root 'projects/README.md'
$inventory = Get-Content -Raw -Encoding UTF8 $inventoryPath
$knownIds = @{}
$primaryFound = $false
foreach ($stateFile in $stateFiles) {
  $state = Get-Content -Raw -Encoding UTF8 $stateFile.FullName
  $idMatch = [regex]::Match($state, '(?m)^project_id:\s*([A-Za-z0-9._-]+)\s*$')
  if (!$idMatch.Success) { Fail "No valid project_id in $($stateFile.FullName)" }
  $projectId = $idMatch.Groups[1].Value
  if ($knownIds.ContainsKey($projectId)) { Fail "Duplicate project_id: $projectId" }
  $knownIds[$projectId] = $stateFile.FullName
  if ($state -notmatch '(?m)^status:\s*(idea|specified|planned|in_production|in_progress|awaiting_review|accepted|shipped|measured|blocked)\s*$') { Fail "Invalid lifecycle status in $($stateFile.FullName)" }
  foreach ($field in @('source_of_truth', 'deliverables', 'blockers', 'authorization', 'paths', 'red_lines')) {
    if ($state -notmatch "(?m)^${field}:\s*") { Fail "$projectId is missing contract field: $field" }
  }
  $projectDir = Split-Path -Parent $stateFile.FullName
  if (!(Test-Path -LiteralPath (Join-Path $projectDir 'README.md') -PathType Leaf)) { Fail "$projectId is missing project README.md" }
  $consoleMatch = [regex]::Match($state, '(?m)^\s*control_console:\s*(\S+)')
  if (!$consoleMatch.Success) { Fail ('Missing paths.control_console for ' + $projectId) }
  $consoleDeclared = $consoleMatch.Groups[1].Value.Replace('\', '/').TrimEnd('/')
  $consoleExpected = 'projects/' + (Split-Path -Leaf $projectDir)
  if (!$consoleDeclared.EndsWith($consoleExpected, [System.StringComparison]::OrdinalIgnoreCase)) {
    Fail ('control_console does not point at the project console: ' + $projectId)
  }
  $receiptsDir = Join-Path $projectDir 'receipts'
  if (!(Test-Path -LiteralPath (Join-Path $receiptsDir 'README.md') -PathType Leaf)) { Fail "$projectId is missing receipts/README.md" }
  if ($inventory -notmatch [regex]::Escape($projectId)) { Fail "$projectId is not registered in projects/README.md" }
  if ($projectId -eq 'tiangong-rebuild-v1') { $primaryFound = $true }
}
if (!$primaryFound) { Fail 'Main project state is not tiangong-rebuild-v1' }

foreach ($prefix in @('04_', '05_', '06_', '07_')) {
  $matches = @(Get-ChildItem -LiteralPath $root -File -Filter "$prefix*.md" -ErrorAction SilentlyContinue)
  if ($matches.Count -eq 0) { Fail "Mapped stage runbook is missing for prefix: $prefix" }
}

# ---- 扫描范围：排除依赖环境、运行时目录和生成媒体 ----
$sep = [System.IO.Path]::DirectorySeparatorChar
$altSep = [System.IO.Path]::AltDirectorySeparatorChar
$excludedSegments = @('node_modules', '.venv', 'venv', '__pycache__', '.browser-profile', '.git', '.cache', 'tmp', 'temp')
$generatedPrefixes = @(('mj-automation' + $sep + 'output'), ('mj-automation' + $sep + 'archive'), ('mj-automation' + $sep + 'run'))
$binaryExtensions = @('.png', '.jpg', '.jpeg', '.webp', '.gif', '.ico', '.bmp', '.tif', '.tiff', '.mp4', '.mov', '.webm', '.mkv', '.mp3', '.wav', '.m4a', '.flac', '.zip', '.7z', '.rar', '.gz', '.pdf', '.pyd', '.dll', '.exe', '.so', '.dylib', '.bin', '.woff', '.woff2', '.ttf', '.otf', '.pyc', '.db', '.sqlite')
function Get-RelativePath([System.IO.FileInfo]$File) {
  return $File.FullName.Substring($root.Length).TrimStart($sep, $altSep).Replace($altSep, $sep)
}
function Test-GovernedPath([System.IO.FileInfo]$File) {
  $relative = Get-RelativePath $File
  foreach ($part in $relative.Split($sep)) {
    if ($excludedSegments -contains $part) { return $false }
  }
  foreach ($prefix in $generatedPrefixes) {
    if ($relative.StartsWith($prefix + $sep, [System.StringComparison]::OrdinalIgnoreCase)) { return $false }
  }
  return $true
}
function Test-ScannableText([System.IO.FileInfo]$File) {
  if ($File.Length -eq 0 -or $File.Length -gt 4MB) { return $false }
  if (!(Test-GovernedPath $File)) { return $false }
  if ($binaryExtensions -contains $File.Extension.ToLowerInvariant()) { return $false }
  return $true
}
$scanCandidates = @()
$scanCandidates += Get-ChildItem -LiteralPath $root -File -ErrorAction SilentlyContinue
foreach ($directory in @('docs', 'projects', 'skills', 'skills-archive', 'reference', 'mj-automation', 'scripts', '.github', 'templates')) {
  $directoryPath = Join-Path $root $directory
  if (!(Test-Path -LiteralPath $directoryPath)) { continue }
  try {
    $scanCandidates += Get-ChildItem -LiteralPath $directoryPath -Recurse -File -ErrorAction SilentlyContinue
  } catch {
    # A stale external link must not make the verifier inspect outside the workspace.
  }
}
$scanFiles = @($scanCandidates | Where-Object { Test-ScannableText $_ })
$allText = $scanFiles | Get-Content -Raw -Encoding UTF8 -ErrorAction SilentlyContinue
$joined = $allText -join "`n"
$secretPatterns = @(
  '(?i)api[_-]?key\s*[:=]\s*["''][A-Za-z0-9_\-]{16,}["'']',
  '(?i)(access|refresh)[_-]?token\s*[:=]\s*["''][A-Za-z0-9_\-\.]{16,}["'']',
  '(?i)-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----',
  '(?i)\b(password|passwd|secret)\s*[:=]\s*["''][^"'']{8,}["'']'
)
foreach ($pattern in $secretPatterns) {
  if ($joined -match $pattern) { Fail "Potential secret pattern detected: $pattern" }
}

# ---- Markdown 基本结构 ----
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

# ---- 技能副本元数据 ----
$skillFiles = @()
foreach ($skillRoot in @('skills', 'skills-archive')) {
  $skillPath = Join-Path $root $skillRoot
  if (!(Test-Path -LiteralPath $skillPath)) { continue }
  $skillFiles += @(Get-ChildItem -LiteralPath $skillPath -Recurse -File -Filter 'SKILL.md' -ErrorAction SilentlyContinue)
}
if ($skillFiles.Count -eq 0) { Fail 'No SKILL.md found under skills/ or skills-archive/' }
foreach ($file in $skillFiles) {
  $relative = Get-RelativePath $file
  $lines = @(Get-Content -LiteralPath $file.FullName -Encoding UTF8 -ErrorAction SilentlyContinue)
  if ($lines.Count -lt 3 -or $lines[0].Trim() -ne '---') { Fail ('SKILL.md is missing YAML frontmatter: ' + $relative) }
  $close = -1
  for ($i = 1; $i -lt $lines.Count; $i++) {
    if ($lines[$i].Trim() -eq '---') { $close = $i; break }
  }
  if ($close -lt 0) { Fail ('SKILL.md frontmatter is not closed: ' + $relative) }
  if ($close -le 1) { Fail ('SKILL.md frontmatter is empty: ' + $relative) }
  $block = @($lines[1..($close - 1)])
  $names = @($block | Where-Object { $_ -match '^name:\s*\S' })
  $descriptions = @($block | Where-Object { $_ -match '^description:\s*\S' })
  if ($names.Count -ne 1) { Fail ('SKILL.md must declare exactly one name, found ' + $names.Count + ': ' + $relative) }
  if ($descriptions.Count -ne 1) { Fail ('SKILL.md must declare exactly one description, found ' + $descriptions.Count + ': ' + $relative) }
  $declared = ($names[0] -replace '^name:\s*', '').Trim()
  $expected = Split-Path -Leaf (Split-Path -Parent $file.FullName)
  if ($declared -ne $expected) { Fail ('SKILL.md name does not match its directory: ' + $relative) }
  if ($close -lt ($lines.Count - 1)) {
    $trailing = @($lines[($close + 1)..($lines.Count - 1)] | Where-Object { $_ -match '^name:\s*\S' })
    if ($trailing.Count -gt 0) { Fail ('SKILL.md has a duplicated frontmatter block: ' + $relative) }
  }
}

Write-Output 'VERIFY PASS: governance files, project state, secret-pattern, Markdown structure, reference-integrity, and skill-metadata checks succeeded.'
