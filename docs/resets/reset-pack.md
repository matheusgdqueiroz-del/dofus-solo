# Reset Pack

- Date: 2026-04-10
- Repo path: `N:\Codex_Programs\Dofus 2 private_2`
- Old reference path: `N:\Codex_Programs\Dofus 2 private`
- Active branch: `work/s02-pregame-existing-character-to-map`
- Sprint start checkpoint: `cp-20260410-0018-s02-architect-define-sprint-2-active-docs`
- Rollback checkpoint: `cp-20260410-0020-s02-orchestrator-sprint-2-rollback-no-runtime-surface`
- Sprint final checkpoint: `cp-20260410-0047-s02-orchestrator-add-minimum-executable-surface`
- Last known remote: `origin/main`

## Current state

- Sprint 2 stays on the same branch but is now formally reclassified.
- The repo foundation from Sprint 0 is preserved and remains the safe base.
- Sprint 1 documentation is complete and stays as the planning baseline.
- The original Sprint 2 gameplay goal was rolled back because there was still no runnable surface in the repo.
- The reclassified Sprint 2 executable-surface intake is now complete.
- The repo now contains a minimal runnable .NET console shell in `src/MinimumExecutableSurface`.
- The exact proof commands are:
  - `dotnet build src/MinimumExecutableSurface/MinimumExecutableSurface.csproj`
  - `dotnet run --project src/MinimumExecutableSurface/MinimumExecutableSurface.csproj --no-build`
- The proof artifact path is `N:\Codex_Programs\Dofus 2 private_2\docs\evidence\s02-minimum-executable-surface\health.json`.
- The artifact remained deterministic across two consecutive runs with SHA256 `3E3C34BF976F00C8E0CF640D1C00FCF624940A27ED74BEF68EE092C11800DC8B`.
- Sprint 2 now closes at `build + run + local artifact` proof only and makes no gameplay claim.
- No gameplay, auth, launcher, protocol, or bootstrap area was reopened.
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

- Sprint 2 introduced the first repo-local executable surface on `work/s02-pregame-existing-character-to-map`.
- That surface is a narrow .NET console health shell that builds, runs, and writes a deterministic repo-local artifact.
- The sprint stopped at executable-surface proof and made no gameplay claim.

## Open risks

- The old project can still contaminate decisions if copied blindly.
- The next attempt can drift into an unsafe broad intake if it tries to solve more than `populated account -> existing character selection -> map`.
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

Then use the existing executable surface as the runnable baseline and resume the next narrow gameplay slice only if the work stays inside `populated account -> existing character selection -> map`.
