# Current Sprint

- Date: 2026-04-10
- Sprint: `S02 - Minimum Executable Surface Intake`
- Status: `completed`
- Branch: `work/s02-pregame-existing-character-to-map`
- Start checkpoint: `cp-20260410-0018-s02-architect-define-sprint-2-active-docs`
- Rollback checkpoint: `cp-20260410-0020-s02-orchestrator-sprint-2-rollback-no-runtime-surface`
- Execution checkpoint before implementation: `cp-20260410-0044-s02-orchestrator-mark-sprint-2-execution-start`

## Goal

Introduce the smallest runnable surface inside the new repo so later sprints can safely return to `populated account -> existing character selection -> map` without bulk-copying the old project.

## In scope

- The smallest repo-local executable shell needed to prove the rebuild can build and run something from inside this repo.
- The smallest repo-local runtime path needed to emit a deterministic health artifact or log from that shell.
- Narrow intake of support-only files strictly required for that shell to build and run.
- Tracking updates tied directly to this executable-surface intake.

## Out of scope

- Any gameplay slice, including `populated account -> existing character selection -> map`.
- Empty-account flow, character creation, create-via-selection, tutorial, quest, combat, or movement.
- Any auth, launcher, protocol, or bootstrap work.
- Any broad refactor, helper rewrite, dependency swap, or old-project bulk copy.
- Any attempt to prove map load, selection success, or other gameplay behavior in this sprint.

## Success criteria

- The repo gains a minimal executable surface that can be built and run locally from inside this repo.
- That surface produces at least one deterministic repo-local runtime artifact or health log.
- The command or script to build and run that surface is documented in the sprint notes or plan.
- The intake stays narrow and support-only, with no gameplay claim attached to it.

## Allowed paths

- The smallest support-only code, config, and scripts required to build and run the executable surface.
- Tracking and reset documents tied to this sprint.
- Repo-local runtime output paths used only for proof of execution.

## Prohibited paths

- Any gameplay, client patching, account flow, selection flow, map load, or log-first gameplay proof.
- Any broad patch, helper rewrite, dependency swap, or old-project bulk copy.
- Any work that reopens auth, launcher, protocol, or bootstrap.

## Current blocker

Resolved in this sprint. The repo now has a minimal repo-local executable shell, so the executable-surface blocker is no longer the active stop point for the rebuild.

## Rollback triggers

- The intake requires gameplay, selection, map, tutorial, quest, combat, or movement work to close the sprint.
- The intake requires auth, launcher, protocol, or bootstrap work.
- The smallest executable shell still expands into a broad runtime import or old-project rescue attempt.
- Two narrow hypotheses fail.
- The traced fix requires a broad patch, helper rewrite, dependency swap, or old-project bulk copy.

## Reclassification note

- The original Sprint 2 gameplay slice was stopped by rollback for lack of runtime surface.
- Sprint 2 now targets that earlier blocker directly instead of trying to close `existing character selection -> map`.
- No gameplay proof is expected in the reclassified sprint.

## Execution result

- The smallest executable surface introduced is a support-only .NET console shell in `src/MinimumExecutableSurface`.
- Build command: `dotnet build src/MinimumExecutableSurface/MinimumExecutableSurface.csproj`
- Run command: `dotnet run --project src/MinimumExecutableSurface/MinimumExecutableSurface.csproj --no-build`
- Proof artifact: `docs/evidence/s02-minimum-executable-surface/health.json`
- Determinism check: two consecutive runs produced the same SHA256 for the proof artifact: `3E3C34BF976F00C8E0CF640D1C00FCF624940A27ED74BEF68EE092C11800DC8B`
- Scope stop respected: no gameplay, auth, launcher, protocol, or bootstrap work was added.

## Next narrow step

Return safely to the blocked slice `populated account -> existing character selection -> map`, using the new executable surface only as the runnable baseline and keeping proof centered on fresh logs/artifacts rather than screenshots.
