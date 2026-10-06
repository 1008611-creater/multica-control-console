param(
    [Parameter(Mandatory = $true)]
    [string]$FixtureFile,
    [Parameter(Mandatory = $true)]
    [string]$OutputDir
)

$ErrorActionPreference = 'Stop'

function Assert-Condition([bool]$Condition, [string]$Message) {
    if (-not $Condition) { throw $Message }
}

function Get-Text([object]$Value) {
    if ($null -eq $Value) { return '' }
    return [string]$Value
}

$fixturePath = (Resolve-Path -LiteralPath $FixtureFile).Path
$outputPath = [System.IO.Path]::GetFullPath($OutputDir)
New-Item -ItemType Directory -Path $outputPath -Force | Out-Null

try {
    $fixture = Get-Content -LiteralPath $fixturePath -Raw -Encoding UTF8 | ConvertFrom-Json

    Assert-Condition ((Get-Text $fixture.mode) -eq 'dry_run') 'fixture.mode must be dry_run'
    Assert-Condition ((Get-Text $fixture.bridge_policy.allow_network) -eq 'False') 'dry-run must disable network access'
    Assert-Condition ([int]$fixture.bridge_policy.network_requests -eq 0) 'fixture records a network request'
    Assert-Condition ([int]$fixture.bridge_policy.paid_calls -eq 0) 'fixture records a paid call'
    Assert-Condition ((Get-Text $fixture.bridge_policy.images_generated) -eq 'False') 'fixture records generated images'
    Assert-Condition ((Get-Text $fixture.authorization.paid_generation) -eq 'not_authorized') 'dry-run fixture must not contain paid authorization'
    Assert-Condition ([int]$fixture.execution.main_workspace_write_attempts -eq 0) 'dry-run must not write the main workspace'
    Assert-Condition ($fixture.items.Count -ge 4) 'fixture must cover four scenarios'

    $requiredFields = @('item_id', 'scenario', 'attempts')
    $rows = [System.Collections.Generic.List[string]]::new()
    $receiptRows = [System.Collections.Generic.List[string]]::new()
    $seen = @{}

    foreach ($item in $fixture.items) {
        foreach ($field in $requiredFields) {
            Assert-Condition ($null -ne $item.$field) ("missing item field: {0}" -f $field)
        }

        $itemId = Get-Text $item.item_id
        Assert-Condition (-not $seen.ContainsKey($itemId)) ("duplicate item_id: {0}" -f $itemId)
        $seen[$itemId] = $true
        Assert-Condition ($item.attempts.Count -ge 1) ("no attempts for {0}" -f $itemId)

        $previousAttempt = $null
        $attemptIndex = 0
        foreach ($attempt in $item.attempts) {
            $attemptIndex++
            Assert-Condition ([int]$attempt.attempt_number -eq $attemptIndex) ("attempt numbering is not sequential for {0}" -f $itemId)
            foreach ($field in @('attempt_id', 'attempt_status', 'retry_allowed', 'charge_status', 'image_paths', 'evidence_ref')) {
                Assert-Condition ($null -ne $attempt.$field) (("missing attempt field {0} for {1}" -f $field, $itemId))
            }
            if ($attemptIndex -eq 1) {
                Assert-Condition ((Get-Text $attempt.retry_of) -eq 'none') (("first attempt retry_of is not none for {0}" -f $itemId))
            } else {
                Assert-Condition ((Get-Text $attempt.retry_of) -eq (Get-Text $previousAttempt.attempt_id)) (("retry_of does not point to previous attempt for {0}" -f $itemId))
            }
            Assert-Condition ((Get-Text $attempt.image_paths) -eq '缺') (("dry-run must not claim an image path for {0}" -f $itemId))
            $previousAttempt = $attempt
        }

        $scenario = Get-Text $item.scenario
        switch ($scenario) {
            'success' {
                Assert-Condition ($item.attempts.Count -eq 1) (("success scenario must have one attempt for {0}" -f $itemId))
                Assert-Condition ((Get-Text $item.attempts[0].attempt_status) -eq 'succeeded') (("success scenario is not succeeded for {0}" -f $itemId))
            }
            'retry_success' {
                Assert-Condition ($item.attempts.Count -eq 2) (("retry scenario must have two attempts for {0}" -f $itemId))
                Assert-Condition ((Get-Text $item.attempts[0].attempt_status) -eq 'failed') (("first retry attempt is not failed for {0}" -f $itemId))
                Assert-Condition ((Get-Text $item.attempts[0].retry_allowed) -eq 'yes') (("retry was not allowed for {0}" -f $itemId))
                Assert-Condition ((Get-Text $item.attempts[1].attempt_status) -eq 'succeeded') (("retry did not succeed for {0}" -f $itemId))
            }
            'no_retry' {
                Assert-Condition ($item.attempts.Count -eq 1) (("no-retry scenario has extra attempts for {0}" -f $itemId))
                Assert-Condition ((Get-Text $item.attempts[0].attempt_status) -eq 'failed_no_retry') (("no-retry status is wrong for {0}" -f $itemId))
                Assert-Condition ((Get-Text $item.attempts[0].retry_allowed) -eq 'no') (("no-retry flag is wrong for {0}" -f $itemId))
            }
            'blocked_unknown_charge' {
                Assert-Condition ($item.attempts.Count -eq 1) (("blocked scenario has extra attempts for {0}" -f $itemId))
                Assert-Condition ((Get-Text $item.attempts[0].attempt_status) -eq 'blocked') (("blocked status is wrong for {0}" -f $itemId))
                Assert-Condition ((Get-Text $item.attempts[0].charge_status) -eq 'unknown') (("blocked charge status is wrong for {0}" -f $itemId))
            }
            default { throw ("unknown scenario: {0}" -f (Get-Text $item.scenario)) }
        }

        $finalAttempt = $item.attempts[$item.attempts.Count - 1]
        $rows.Add(("| {0} | {1} | {2} | {3} | {4} |" -f $itemId, (Get-Text $item.scenario), (Get-Text $finalAttempt.attempt_status), (Get-Text $finalAttempt.charge_status), (Get-Text $finalAttempt.image_paths)))
        $receiptRows.Add(("- {0}: final={1}; attempts={2}; retry_of={3}; charge={4}; image={5}" -f $itemId, (Get-Text $finalAttempt.attempt_status), $item.attempts.Count, (Get-Text $finalAttempt.retry_of), (Get-Text $finalAttempt.charge_status), (Get-Text $finalAttempt.image_paths)))
    }

    $report = [System.Collections.Generic.List[string]]::new()
    $report.Add('# AIGC 抽卡无付费 dry-run 报告')
    $report.Add('')
    $report.Add('- 运行模式：`dry_run`')
    $report.Add('- 真实 Multica：未启动')
    $report.Add('- 抽卡桥：未访问')
    $report.Add('- 付费接口：未调用')
    $report.Add('- 图片生成：未发生')
    $report.Add('- 主工作区写入：未发生')
    $report.Add('- 结论：`PASS`')
    $report.Add('')
    $report.Add('## 模拟状态覆盖')
    $report.Add('')
    $report.Add('| 编号 | 场景 | 最终状态 | 扣费状态 | 图片路径 |')
    $report.Add('|---|---|---|---|---|')
    foreach ($row in $rows) { $report.Add($row) }
    $report.Add('')
    $report.Add('## 通过标准')
    $report.Add('')
    $report.Add('- [x] 输入包可读，未知字段写「缺」')
    $report.Add('- [x] 没有真实桥请求、付费调用或图片生成')
    $report.Add('- [x] 串行状态、失败重提、不重试和阻塞规则通过')
    $report.Add('- [x] 主工作区未被修改')
    $report.Add('- [x] 模拟回执保留原始失败和 `retry_of` 关系')
    $report.Add('- [ ] 真实桥提交、图片回收和实际扣费状态：未验证')
    $report.Add('')
    $report.Add('## 交付边界')
    $report.Add('')
    $report.Add('本报告只证明本地静态 dry-run 规则通过，不证明 Multica、抽卡桥或平台生产链路已通过。')

    $receipt = [System.Collections.Generic.List[string]]::new()
    $receipt.Add('# AIGC 抽卡 dry-run 模拟回执')
    $receipt.Add('')
    $receipt.Add('- 回执类型：`dry_run_only`')
    $receipt.Add('- 真实作业号：缺')
    $receipt.Add('- 真实序列号：缺')
    $receipt.Add('- 图片文件：缺（本次明确不生成图片）')
    $receipt.Add('')
    foreach ($line in $receiptRows) { $receipt.Add($line) }

    $stateMap = [ordered]@{
        mode = 'dry_run'
        batch_id = $fixture.batch_id
        project_id = $fixture.project_id
        final_status = 'dry_run_validated'
        bridge_access = 'not_attempted'
        paid_generation = 'not_attempted'
        main_workspace_write = 'not_attempted'
        items = @($fixture.items | ForEach-Object {
            $last = $_.attempts[$_.attempts.Count - 1]
            [ordered]@{
                item_id = $_.item_id
                scenario = $_.scenario
                final_status = $last.attempt_status
                attempt_count = $_.attempts.Count
                retry_of = $last.retry_of
                charge_status = $last.charge_status
                image_paths = '缺'
            }
        })
    }

    $manifest = @(
        '# Dry-run handoff manifest',
        '',
        '- `dry-run-report.md`: 验收结果与边界',
        '- `dry-run-receipt.md`: 模拟回执',
        '- `dry-run-state-map.json`: 模拟状态映射',
        '- 所有文件均属于 dry-run 产物，不得作为真实生产回执或图片证据。'
    )

    $reportPath = Join-Path $outputPath 'dry-run-report.md'
    $receiptPath = Join-Path $outputPath 'dry-run-receipt.md'
    $statePath = Join-Path $outputPath 'dry-run-state-map.json'
    $manifestPath = Join-Path $outputPath 'handoff-manifest.md'
    $report | Set-Content -LiteralPath $reportPath -Encoding UTF8
    $receipt | Set-Content -LiteralPath $receiptPath -Encoding UTF8
    ($stateMap | ConvertTo-Json -Depth 10) | Set-Content -LiteralPath $statePath -Encoding UTF8
    $manifest | Set-Content -LiteralPath $manifestPath -Encoding UTF8

    Write-Output 'DRY-RUN PASS'
    Write-Output ("REPORT: {0}" -f $reportPath)
    Write-Output ("RECEIPT: {0}" -f $receiptPath)
    Write-Output ("STATE_MAP: {0}" -f $statePath)
    Write-Output ("MANIFEST: {0}" -f $manifestPath)
}
catch {
    Write-Error ('DRY-RUN FAIL: ' + $_.Exception.Message)
    exit 1
}
