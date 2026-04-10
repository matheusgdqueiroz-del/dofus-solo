# Reset Pack

- Date: 2026-04-10
- Repo path: `N:\Codex_Programs\Dofus 2 private_2`
- Old reference path: `N:\Codex_Programs\Dofus 2 private`
- Active branch: `work/s01-baseline-audit-safe`
- Last known remote: `origin/main`

## Current state

- Sprint 1 is open on a dedicated sprint branch.
- The repo foundation from Sprint 0 is preserved and remains the safe base.
- The current sprint is documentation-only and does not touch gameplay code.
- The old project remains outside this repo and is reference-only.

## What is already decided

- `thread_final.md` is the main historical source.
- Main branch must stay green.
- Work happens in sprint branches.
- Checkpoints must be script-driven.
- No broad refactors and no bulk copying from the old project.
- Every role must end with a copy-paste-ready next prompt.
- The first safe rebuild baseline is `populated account -> character selection -> map`.

## Last durable delta

- Sprint 1 scope is now locked:
  - safe initial baseline chosen
  - baseline matrix expanded
  - decision ledger aligned
  - reset path aligned with the active sprint

## Open risks

- The old project can still contaminate decisions if copied blindly.
- Sprint 1 can drift into gameplay, tutorial, combat, or quest work if the baseline boundary is not enforced.
- Closed areas like auth, launcher, protocol, and bootstrap can be reopened by habit without fresh evidence.

## Next first step after reset

Open these files in order:

1. `AGENTS.md`
2. `docs/tracking/current-sprint.md`
3. `docs/plans/PLAN-s01-baseline-audit-safe.md`
4. `docs/tracking/baseline-matrix.md`
5. `docs/tracking/decision-ledger.md`
6. `threads/thread_final.md`
