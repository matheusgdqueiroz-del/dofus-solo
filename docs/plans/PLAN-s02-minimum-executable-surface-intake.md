# PLAN S02 - Minimum Executable Surface Intake

## Summary

Introduce the smallest runnable surface into the new rebuild repo so later sprints can safely return to `populated account -> existing character selection -> map`.

## Exact objective

- Make the repo able to build and run one minimal support-only executable surface locally.
- Make that surface emit one deterministic repo-local runtime artifact or health log.
- Stop there.

## Mandatory

- Keep one primary blocker: missing executable surface in the new repo.
- Add only the smallest support-only code, config, and scripts required to build and run that surface.
- Keep the surface local to this repo and easy to rollback.
- Record the exact build/run command and the exact proof artifact path.

## Recommended

- Prefer a narrow shell that proves build + run + local artifact creation without claiming gameplay.
- Prefer deterministic runtime output paths over ad-hoc manual proof.
- Keep any intake small enough that each imported file can be justified as necessary for the executable shell.

## Optional

- Add one short operator note if the build/run command is not obvious from file names alone.
- Add one small health-check artifact format if it reduces ambiguity for later sprints.

## Prohibited

- Any attempt to close `populated account -> existing character selection -> map` in this sprint.
- Any auth, launcher, protocol, or bootstrap work.
- Any tutorial, quest, combat, NPC, map, or movement work.
- Any broad refactor, helper rewrite, dependency swap, or bulk copy from `N:\Codex_Programs\Dofus 2 private`.

## Success criteria

- A minimal executable surface exists inside this repo.
- The repo can build and run that surface locally.
- The run emits at least one deterministic repo-local artifact or health log.
- The sprint stops without making any gameplay claim.

## Risks

- Scope drift into gameplay or other pregame behavior.
- Reopening closed sensitive areas by habit.
- Pulling in too much of the old project to solve a small surface problem.
- Creating a shell that runs but is too vague to support the next sprint safely.

## Rollback triggers

- The intake needs auth, launcher, protocol, or bootstrap work.
- The intake expands into a broad runtime import or old-project rescue path.
- Two narrow executable-surface hypotheses fail.
- The sprint starts requiring gameplay proof instead of executable-surface proof.

## Next narrow step after success

Return to the blocked gameplay slice: `populated account -> existing character selection -> map`.
