# ADR-0005: Keep three submitted bridge slots while the browser profile is locked

- Status: accepted
- Date: 2026-09-27

## Decision

The local MJ adapter keeps the batch API at up to three queued or running jobs while the shared browser profile is serialized by a file lock. The default lock wait is 1,200,000 ms (20 minutes), matching the bridge task timeout.

## Reason

A 300-second lock wait caused queued jobs to be marked failed while an earlier Midjourney generation was still producing. Those failures consumed retry attempts and left fewer than three active slots. Extending the wait preserves the user-confirmed three-slot policy without opening multiple Playwright contexts against the same profile.

## Verification

- `node --check mj-automation/scripts/mxai_adapter.js`
- `npm run verify`
- `mj_run.js` clamps inherited `MXAI_LOCK_WAIT_MS` values below 1,200,000 ms before loading the adapter.
- Runtime health endpoint remains `ok=true`, model `midjourney`, version `v8.2`.

## Limits

The provider still returns a four-image grid per generation. Individual tile selection/upscale remains a separate manual or future bridge capability; grid files are not marked as final video references until visual QA.
