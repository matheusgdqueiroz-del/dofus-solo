# Current Sprint

- Date: 2026-04-10
- Sprint: `S01 - Baseline Audit Safe`
- Status: `active`
- Branch: `work/s01-baseline-audit-safe`

## Goal

Close, in writing, what enters the new rebuild now, what stays for later revalidation, and what remains reference-only from the old project.

## In scope

- Audit the safe intake for the new rebuild using `threads/thread_final.md` as the main source.
- Lock the safest initial baseline for the rebuild.
- Classify each important area as `carry forward now`, `revalidate later`, or `reference only`.
- Update planning and tracking docs for Sprint 1.

## Out of scope

- Gameplay implementation.
- Combat.
- Guided Tutorial.
- Quest flow.
- Runtime, client, server, launcher, auth, protocol, or bootstrap work.
- Any bulk import from the old project.

## Success criteria

- The safest initial baseline is defined without ambiguity.
- `docs/tracking/baseline-matrix.md` clearly classifies the important areas.
- The old project is documented as reference-only.
- `docs/resets/reset-pack.md` and `docs/tracking/decision-ledger.md` match the Sprint 1 scope.
- No files outside planning, tracking, and reset docs are changed.

## Allowed paths

- `docs/plans/**`
- `docs/tracking/**`
- `docs/resets/reset-pack.md`

## Prohibited paths

- Any gameplay or runtime code.
- Any client, server, or asset changes.
- Any large import from `N:\Codex_Programs\Dofus 2 private`.
- Any attempt to save or reuse the old project as a base.

## Current blocker

None. The sprint is documentation-only and can proceed from the Sprint 0 foundation.

## Next narrow step

Execute the first implementation sprint only for the chosen pregame baseline: populated account -> character selection -> map.
