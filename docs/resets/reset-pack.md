# Reset Pack

- Date: 2026-04-09
- Repo path: `N:\Codex_Programs\Dofus 2 private_2`
- Old reference path: `N:\Codex_Programs\Dofus 2 private`
- Active branch: `work/s00-foundation-safe`
- Last known remote: `origin/main`

## Current state

- The new rebuild repo now exists locally under Git.
- The historical `threads/` folder is present and should be preserved.
- The old project remains outside this repo and is reference-only.
- The foundation docs and checkpoint scripts are installed.

## What is already decided

- `thread_final.md` is the main historical source.
- Main branch must stay green.
- Work happens in sprint branches.
- Checkpoints must be script-driven.
- No broad refactors and no bulk copying from the old project.
- Every role must end with a copy-paste-ready next prompt.

## Last durable delta

- Safe rebuild foundation is complete:
  - repo initialized
  - branch model defined
  - docs structure created
  - checkpoint workflow scripted
  - local script validation passed

## Open risks

- The old project can still contaminate decisions if copied blindly.
- The remote repo is still very empty and should not be mistaken for a usable gameplay baseline.

## Next first step after reset

Open these files in order:

1. `AGENTS.md`
2. `docs/tracking/current-sprint.md`
3. `docs/tracking/decision-ledger.md`
4. `docs/tracking/evidence-index.jsonl`
5. `threads/thread_final.md`
6. `docs/tracking/baseline-matrix.md`
7. `docs/ops/copy-paste-workflow.md`
