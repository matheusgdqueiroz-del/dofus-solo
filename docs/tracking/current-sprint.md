# Current Sprint

- Date: 2026-04-10
- Sprint: `S02 - Pregame Existing Character To Map`
- Status: `stopped by rollback`
- Branch: `work/s02-pregame-existing-character-to-map`
- Start checkpoint: `cp-20260410-0018-s02-architect-define-sprint-2-active-docs`
- Rollback checkpoint: `cp-20260410-0020-s02-orchestrator-sprint-2-rollback-no-runtime-surface`

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

The sprint branch has no runnable rebuild surface yet. A fresh tree scan of `HEAD` shows only docs, prompts, scripts, and threads; there is no runtime, client, server, launcher, harness, or log path inside this repo to execute `populated account -> existing character selection -> map`.

## Rollback triggers

- The flow requires empty-account, create-via-selection, tutorial, quest, combat, or movement work to close the sprint.
- The blocker moves outside the existing-character selection -> map path.
- Two narrow hypotheses fail.
- The traced fix requires a broad patch, helper rewrite, dependency swap, or reopening auth/launcher/protocol/bootstrap without stronger evidence.

## Rollback outcome

- Trigger hit: the real blocker sits before the allowed `selection -> map` trail because the new rebuild repo does not yet contain the runnable implementation surface required to test or patch this slice.
- Continuing Sprint 2 from this branch would require a broad runtime intake or old-project code import, which violates the narrow-scope rules for this sprint.
- No fresh `world.log` or screenshots were collected, because there is no executable client/server path in the current repo to generate them.

## Next narrow step

Return to planning and define the smallest safe pre-runtime intake sprint that can introduce a runnable baseline into the rebuild without bulk-copying the old project.
