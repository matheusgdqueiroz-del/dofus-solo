# Current Sprint

- Date: 2026-04-10
- Sprint: `S02 - Pregame Existing Character To Map`
- Status: `active`
- Branch: `work/s02-pregame-existing-character-to-map`

## Goal

Reprove the smallest safe pregame slice in the new rebuild through the real user flow: populated account -> existing character selection -> map.

## In scope

- Populated account only.
- Existing character selection visibility.
- Existing character selection success.
- Post-selection context and first map load only if required to land on the first map.
- Tracking updates tied directly to fresh proof collected in this sprint.

## Out of scope

- Empty-account flow.
- Character creation from an empty account.
- Create-via-selection flow.
- Tutorial, quest, combat, or movement after spawn.
- Any broad refactor, helper rewrite, dependency swap, or old-project bulk copy.
- Reopening auth, launcher, protocol, or bootstrap without fresh stronger evidence.

## Success criteria

- Fresh real-user run reaches visible existing-character selection with a populated account.
- Selecting one existing character succeeds and lands on the first map.
- Fresh `world.log` from that same run proves selection success.
- Fresh `world.log` from that same run proves post-selection context or map load.
- Screenshot corroborates visible existing-character selection.
- Screenshot corroborates the map after the selected character loads.

## Allowed paths

- Narrow local fixes directly on the populated-account pregame path.
- Tracking and reset documents tied to this sprint.
- Minimal deterministic patch-state updates only if the traced path proves they are necessary.

## Prohibited paths

- Any work on empty-account creation, tutorial, quest, combat, or movement-after-spawn.
- Any broad patch, helper rewrite, dependency swap, or old-project copy.
- Any reopening of auth, launcher, protocol, or bootstrap without fresh payload, log, or DB proof.

## Current blocker

Unknown until the real populated-account selection-to-map path is re-run on this sprint branch.

## Rollback triggers

- The flow requires empty-account, create-via-selection, tutorial, quest, combat, or movement work to close the sprint.
- The blocker moves outside the existing-character selection -> map path.
- Two narrow hypotheses fail.
- The traced fix requires a broad patch, helper rewrite, dependency swap, or reopening auth/launcher/protocol/bootstrap without stronger evidence.

## Next narrow step

If Sprint 2 closes successfully, the next narrow step is `populated account -> create via selection -> map`.
