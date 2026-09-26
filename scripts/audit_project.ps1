param(
    [Parameter(Mandatory = $true)]
    [Alias('ProjectRoot')]
    [string]$ProjectDir,
    [switch]$Quiet
)
$ErrorActionPreference = 'Stop'
$projectPath = (Resolve-Path -LiteralPath $ProjectDir).Path
$statePath = Join-Path $projectPath 'project_state.yaml'
$readmePath = Join-Path $projectPath 'README.md'
$indexPath = Join-Path (Split-Path $projectPath -Parent) 'README.md'
function Fail([string]$Message) {
    if (-not $Quiet) { Write-Output "FAIL $Message" }
    $script:failed = $true
}
function Pass([string]$Message) {
    if (-not $Quiet) { Write-Output "PASS $Message" }
}

$failed = $false
foreach ($required in @($statePath, $readmePath, $indexPath)) {
    if (-not (Test-Path -LiteralPath $required -PathType Leaf)) { Fail "缺少文件: $required" }
}
if ($failed) { exit 1 }

$state = Get-Content -LiteralPath $statePath -Raw -Encoding UTF8
$readme = Get-Content -LiteralPath $readmePath -Raw -Encoding UTF8
$index = Get-Content -LiteralPath $indexPath -Raw -Encoding UTF8

$idMatch = [regex]::Match($state, '(?m)^project_id:\s*(\S+)\s*$')
if (-not $idMatch.Success) { Fail 'project_state.yaml 缺少 project_id' } else {
    $projectId = $idMatch.Groups[1].Value
    if ($readme -notmatch [regex]::Escape($projectId)) { Fail "README 未登记 project_id: $projectId" } else { Pass "project_id 一致: $projectId" }
    if ($index -notmatch [regex]::Escape($projectId)) { Fail "项目索引未登记 project_id: $projectId" } else { Pass "项目索引已登记 project_id: $projectId" }
}

$statusMatch = [regex]::Match($state, '(?m)^status:\s*(\S+)\s*$')
$allowed = @('backlog','planned','in_progress','in_production','blocked','in_review','accepted','shipped','retrospective','archived')
if (-not $statusMatch.Success) { Fail 'project_state.yaml 缺少 status' } elseif ($allowed -notcontains $statusMatch.Groups[1].Value) {
    Fail "非法 status: $($statusMatch.Groups[1].Value)"
} else { Pass "status 合法: $($statusMatch.Groups[1].Value)" }

foreach ($field in @('source_of_truth','deliverables','blockers','authorization','paths','red_lines')) {
    if ($state -notmatch "(?m)^${field}:\s*") { Fail "缺少契约字段: $field" }
}

$paths = [regex]::Matches($state, '(?m)^\s+path:\s*(\S+)\s*$')
foreach ($match in $paths) {
    $relative = $match.Groups[1].Value
    $candidate = Join-Path $projectPath $relative
    if (-not (Test-Path -LiteralPath $candidate)) { Fail "交付物路径不存在: $relative" } else { Pass "交付物路径存在: $relative" }
}
if ($paths.Count -eq 0) { Fail 'deliverables 未发现 path' }

if ($state -match '(?m)^blockers:\s*\[\s*\]\s*$') { Pass 'blockers 为空，未发现结构化阻塞项' } else { Pass 'blockers 已登记，需结合回执复核' }
if ($state -match '(?m)^authorization:\s*$') { Pass 'authorization 已登记' } else { Fail 'authorization 未形成映射' }

function Get-StateValue([string]$Text, [string]$Names) {
    $pattern = '(?im)^\s*(?:[-*]\s*)?(?:' + $Names + ')\s*:\s*(.+?)\s*$'
    $match = [regex]::Match($Text, $pattern)
    if (-not $match.Success) { return '' }
    return $match.Groups[1].Value.Trim().Trim('"', "'", '`')
}

$missingAuthorities = [System.Collections.Generic.List[string]]::new()
foreach ($authority in @('project_context.json', '01_input_packet.md')) {
    if (-not (Test-Path -LiteralPath (Join-Path $projectPath $authority) -PathType Leaf)) {
        $missingAuthorities.Add($authority)
    }
}
$stage = Get-StateValue $state 'current_stage|stage'
$champion = Get-StateValue $state 'current_champion|champion'
$pendingReview = [regex]::Match($state, '(?im)^\s*pending_review:\s*\[([^\]]*)\]')
$pendingAssets = @()
if ($pendingReview.Success -and $pendingReview.Groups[1].Value.Trim()) {
    $pendingAssets = @($pendingReview.Groups[1].Value.Split(',') | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

if (-not $Quiet) {
    Write-Output '---'
    Write-Output "project_id: $(if ($projectId) { $projectId } else { 'missing' })"
    Write-Output "stage: $(if ($stage) { $stage } else { 'missing' })"
    Write-Output "champion: $(if ($champion) { $champion } else { 'missing' })"
    Write-Output "missing_authorities: $(if ($missingAuthorities.Count) { $missingAuthorities -join ', ' } else { 'none' })"
    if ($pendingAssets.Count -gt 0 -and $missingAuthorities.Count -eq 0 -and $stage -and $champion) {
        Write-Output "earliest_gap: visual acceptance pending for $($pendingAssets -join ', ')"
    } elseif ($missingAuthorities.Count -gt 0) {
        Write-Output "earliest_gap: missing production handoff files: $($missingAuthorities -join ', ')"
    } elseif (-not $stage -or -not $champion) {
        Write-Output 'earliest_gap: current stage or champion is missing'
    } elseif ($failed) {
        Write-Output 'earliest_gap: project contract audit failed'
    } else {
        Write-Output 'earliest_gap: none'
    }
}

if ($failed) { if (-not $Quiet) { Write-Output 'AUDIT FAIL' }; exit 1 }
if (-not $Quiet) {
    Write-Output 'AUDIT PASS (console contract only)'
    if ($missingAuthorities.Count -gt 0) { Write-Output 'PRODUCTION AUDIT BLOCKED; required handoff files missing' }
}
exit 0
