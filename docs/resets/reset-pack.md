# Reset Pack

- Date: 2026-04-10
- Repo path: `N:\Codex_Programs\Dofus 2 private_2`
- Old reference path: `N:\Codex_Programs\Dofus 2 private`
- Active branch: `work/s02-pregame-existing-character-to-map`
- Sprint start checkpoint: `cp-20260410-0018-s02-architect-define-sprint-2-active-docs`
- Rollback checkpoint: `cp-20260410-0020-s02-orchestrator-sprint-2-rollback-no-runtime-surface`
- Last known remote: `origin/main`

## Current state

- Sprint 2 was opened on a dedicated sprint branch and then stopped by rollback.
- The repo foundation from Sprint 0 is preserved and remains the safe base.
- Sprint 1 documentation is complete and stays as the planning baseline.
- Sprint 2 was limited to the first narrow implementation reproof: populated account -> existing character selection -> map.
- The current repo tree still contains only documentation/process scaffolding, so there is no runnable rebuild surface yet for pregame validation.
- The old project remains outside this repo and is reference-only.

## What is already decided

- `thread_final.md` is the main historical source.
- Main branch must stay green.
- Work happens in sprint branches.
- Checkpoints must be script-driven.
- No broad refactors and no bulk copying from the old project.
- Every role must end with a copy-paste-ready next prompt.
- Planner and Architect threads should be reused by default.
- The first safe rebuild baseline is `populated account -> existing character selection -> map`.
- The first implementation sprint must use fresh `world.log` as primary proof and screenshots only as corroboration.
- Sprint 2 cannot resume its original gameplay target until the repo has a minimal executable surface.

## Last durable delta

- Sprint 2 was opened from `work/s01-baseline-audit-safe` into `work/s02-pregame-existing-character-to-map`.
- The active sprint docs now point to the live Sprint 2 branch and keep the exact slice locked as `populated account -> existing character selection -> map`.
- The first Sprint 2 trace stopped cleanly when `git ls-tree -r --name-only HEAD` and the recursive repo scan showed no runtime, client, server, launcher, harness, or log-producing paths in this repo.

## Open risks

- The old project can still contaminate decisions if copied blindly.
- The next attempt can drift into an unsafe broad intake if it tries to close Sprint 2 without first defining how runnable code enters the rebuild.
- Closed areas like auth, launcher, protocol, and bootstrap can be reopened by habit without fresh evidence.

## Next first step after reset

Open these files in order:

1. `AGENTS.md`
2. `docs/tracking/current-sprint.md`
3. `docs/resets/reset-pack.md`
4. `docs/tracking/decision-ledger.md`
5. `docs/tracking/baseline-matrix.md`
6. `docs/tracking/evidence-index.jsonl`
7. `threads/thread_final.md`

Then formally reclassify Sprint 2 into the smallest safe sprint that introduces a runnable rebuild surface into this repo without bulk-copying the old project.
