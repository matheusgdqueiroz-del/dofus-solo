# Reset Pack

- Date: 2026-04-10
- Repo path: `N:\Codex_Programs\Dofus 2 private_2`
- Old reference path: `N:\Codex_Programs\Dofus 2 private`
- Active branch: `work/s02-pregame-existing-character-to-map`
- Last known remote: `origin/main`

## Current state

- Sprint 2 is now active on a dedicated sprint branch.
- The repo foundation from Sprint 0 is preserved and remains the safe base.
- Sprint 1 documentation is complete and stays as the planning baseline.
- Sprint 2 is limited to the first narrow implementation reproof: populated account -> existing character selection -> map.
- The old project remains outside this repo and is reference-only.

## What is already decided

- `thread_final.md` is the main historical source.
- Main branch must stay green.
- Work happens in sprint branches.
- Checkpoints must be script-driven.
- No broad refactors and no bulk copying from the old project.
- Every role must end with a copy-paste-ready next prompt.
- The first safe rebuild baseline is `populated account -> existing character selection -> map`.
- The first implementation sprint must use fresh `world.log` as primary proof and screenshots only as corroboration.

## Last durable delta

- Sprint 2 was opened from `work/s01-baseline-audit-safe` into `work/s02-pregame-existing-character-to-map`.
- The active sprint docs now point to the live Sprint 2 branch and keep the exact slice locked as `populated account -> existing character selection -> map`.

## Open risks

- The old project can still contaminate decisions if copied blindly.
- The active implementation sprint can drift into adjacent pregame paths if the boundary is not enforced.
- Closed areas like auth, launcher, protocol, and bootstrap can be reopened by habit without fresh evidence.

## Next first step after reset

Open these files in order:

1. `AGENTS.md`
2. `docs/tracking/current-sprint.md`
3. `docs/plans/PLAN-s02-pregame-existing-character-to-map.md`
4. `docs/resets/reset-pack.md`
5. `docs/tracking/decision-ledger.md`
6. `docs/tracking/baseline-matrix.md`
7. `docs/tracking/evidence-index.jsonl`
8. `threads/thread_final.md`
