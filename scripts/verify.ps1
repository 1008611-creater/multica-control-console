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
  'docs/adr/0001-workspace-governance.md'
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

$scanFiles = @()
$scanFiles += Get-ChildItem -LiteralPath $root -File -ErrorAction SilentlyContinue
foreach ($directory in @('docs', 'projects', 'skills', 'skills-archive', 'reference')) {
  $directoryPath = Join-Path $root $directory
  if (Test-Path -LiteralPath $directoryPath) {
    try {
      $scanFiles += Get-ChildItem -LiteralPath $directoryPath -Recurse -File -ErrorAction SilentlyContinue
    } catch {
      # A stale external link must not make the verifier inspect outside the workspace.
    }
  }
}
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

Write-Output 'VERIFY PASS: governance files, project state, and secret-pattern checks succeeded.'
