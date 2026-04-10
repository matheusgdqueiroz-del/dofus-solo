# Reset Pack

- Date: 2026-04-10
- Repo path: `N:\Codex_Programs\Dofus 2 private_2`
- Old reference path: `N:\Codex_Programs\Dofus 2 private`
- Active branch: `work/s02-pregame-existing-character-to-map`
- Sprint start checkpoint: `cp-20260410-0018-s02-architect-define-sprint-2-active-docs`
- Rollback checkpoint: `cp-20260410-0020-s02-orchestrator-sprint-2-rollback-no-runtime-surface`
- Last known remote: `origin/main`

## Current state

- Sprint 2 stays on the same branch but is now formally reclassified.
- The repo foundation from Sprint 0 is preserved and remains the safe base.
- Sprint 1 documentation is complete and stays as the planning baseline.
- The original Sprint 2 gameplay goal was rolled back because there is still no runnable surface in the repo.
- The current Sprint 2 goal is the minimum executable-surface intake needed before gameplay can resume safely.
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
- Sprint 2 is now reclassified to create that minimal executable surface first.

## Last durable delta

- Sprint 2 was formally reclassified on `work/s02-pregame-existing-character-to-map`.
- The sprint now targets the smallest repo-local executable surface instead of a gameplay slice.
- The success boundary is now `build + run + deterministic repo-local artifact`, with no gameplay claim attached.

## Open risks

- The old project can still contaminate decisions if copied blindly.
- The next attempt can drift into an unsafe broad intake if it tries to solve gameplay instead of the executable surface.
- Closed areas like auth, launcher, protocol, and bootstrap can be reopened by habit without fresh evidence.

## Next first step after reset

Open these files in order:

1. `AGENTS.md`
2. `docs/tracking/current-sprint.md`
3. `docs/resets/reset-pack.md`
4. `docs/plans/PLAN-s02-minimum-executable-surface-intake.md`
5. `docs/tracking/decision-ledger.md`
6. `docs/tracking/baseline-matrix.md`
7. `docs/tracking/evidence-index.jsonl`
8. `threads/thread_final.md`

Then execute only the minimum executable-surface intake and stop before any gameplay slice.
