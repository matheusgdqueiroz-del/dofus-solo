# PLAN - Return To Existing Character Selection To Map

## Summary

Return safely to the narrow gameplay slice `populated account -> existing character selection -> map`, using the executable surface from Sprint 2 only as the runnable baseline and not as gameplay proof.

## Main hypothesis

- With a repo-local executable surface now proven, the next blocker can be isolated inside the populated-account `existing character selection -> map` trail itself, without reopening auth, launcher, protocol, or bootstrap.

## Obligatory

- Keep one target only: `populated account -> existing character selection -> map`.
- Keep one main hypothesis only: the blocker now sits inside that slice, not in missing executable surface.
- Treat `src/MinimumExecutableSurface` only as runnable baseline, never as gameplay proof.
- Require fresh `world.log` as primary proof for the next slice.
- Use screenshot only as corroboration of selection screen and first map load.
- Stop at first map load.
- If a fresh repo-local `world.log` path cannot be produced inside the allowed scope, rollback immediately.

## Recommended

- Validate freshness of the proof bundle before trusting any UI interpretation.
- Prefer the smallest local delta that restores `existing character selection -> map` proof.
- Keep all notes tied to one observed blocker only.

## Optional

- Add one short operator note if the exact repro command is not obvious from the touched files.
- Add one small diagnostic artifact only if it helps prove log freshness without broadening scope.

## Prohibited

- Empty-account flow.
- Create-via-selection flow.
- Tutorial, quest, combat, or movement after spawn.
- Any auth, launcher, protocol, or bootstrap reopening.
- Any broad refactor, helper rewrite, dependency swap, or bulk copy from `N:\Codex_Programs\Dofus 2 private`.

## Expected evidence

- Fresh `world.log` from the same run showing the populated-account trail.
- Fresh `world.log` from the same run showing existing-character selection success.
- Fresh `world.log` from the same run showing post-selection context or first map load.
- Screenshot as corroboration of visible existing-character selection.
- Screenshot as corroboration of the first loaded map.

## Rollback triggers

- No fresh repo-local `world.log` path can be reached without reopening prohibited areas.
- The work expands into empty-account, create-via-selection, tutorial, quest, combat, or movement.
- The work requires auth, launcher, protocol, or bootstrap changes.
- Two narrow hypotheses fail.
- The blocker clearly moves before or outside `existing character selection -> map`.

## Next narrow step after success

- `populated account -> create via selection -> map`
