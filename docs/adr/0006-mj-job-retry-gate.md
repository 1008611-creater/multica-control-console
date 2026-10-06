# ADR-0006: Require business-state and no-charge proof before MJ retries

- Status: accepted
- Date: 2026-09-27

## Context

The jobs API uses an outer execution status such as `running` or `done`, while the runner's business result is stored in `result.status`. Treating outer `done` as business success/failure hid states such as `queued`, `receipt_pending`, and `download_failed`. The batch runner also retried any non-success and forced a fresh submission, so an ambiguous result could incur a second charge.

## Decision

- Keep the existing outer `status` for bridge execution compatibility and expose `resultStatus`, `retryAllowed`, submission/billing facts, and charge-known state on job reads.
- Preserve both camelCase and snake_case retry flags at the runner boundary.
- Automatically retry only a recognized failure with `retryAllowed: true`, a known no-charge result (`billed: false`, explicit zero deduction, or an explicit `submitted: false`), and remaining per-item retry allowance.
- Never automatically resubmit `queued`, `receipt_pending`, `download_failed`, `need_login`, unknown statuses, polling errors, or submit outcomes whose acceptance/charge is uncertain. A POST error is not proof the job was not accepted.
- Receipts store business result status separately from outer job status and retain retry/billing certainty.

## Verification

- Node regression tests use an injected mock request function and never call the real bridge.
- Python regression tests exercise the same `read_job` contract returned by `/v1/jobs` without starting the bridge.
- `npm test` and `npm run verify` are required before handoff.

## Consequences

Some failures will remain unresolved for human review rather than being retried. This is intentional: known no-charge evidence and an explicit retry permission are required to avoid duplicate paid generations.
