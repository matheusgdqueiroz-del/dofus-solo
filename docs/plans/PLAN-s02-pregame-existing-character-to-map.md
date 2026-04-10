# PLAN S02 - Pregame Existing Character To Map

## Summary

Reprove the smallest safe pregame slice in the new rebuild through the real user flow: populated account -> existing character selection -> map.

## Exact objective

- Reach the character selection screen with a populated account.
- Select one existing character.
- Land on the map once.
- Stop there.

## Deliverables

- One narrow implementation sprint for `work/s02-pregame-existing-character-to-map`
- Only the local fixes needed for populated-account selection and post-selection map entry
- Tracking updates that record what was changed and what proof was collected

## Allowed scope

- Narrow fixes directly on the populated-account pregame path
- Existing character list visibility
- Existing character selection success
- Post-selection context and map entry only if they are required to land on the first map
- Minimal client patch-state or deterministic patch updates only if the path proves they are needed

## Out of scope

- Empty-account creation flow
- Create-via-selection flow
- Tutorial, quest, combat, NPC interaction, movement after spawn, or Incarnam validation
- Auth, launcher, protocol, or bootstrap reopening without fresh payload, log, or DB evidence
- Broad automation work, helper rewrites, refactor, dependency changes, or old-project bulk copy

## Minimum proof of success

- Fresh run through the normal user path, not harness-only proof
- Fresh `world.log` for the same run showing existing-character selection success
- Fresh `world.log` for the same run showing post-selection context or map load
- Screenshot as corroboration of visible character selection with an existing character
- Screenshot as corroboration of the map after the selected character loads

## Risks

- Scope drift into adjacent pregame paths like empty-account or create-via-selection
- Reopening closed areas like auth, launcher, protocol, or bootstrap by habit
- Trusting screenshot alone when logs disagree or are stale
- Mistaking harness-only success for the real user flow

## Rollback triggers

- Any change that pulls in tutorial, quest, combat, or movement-after-spawn work
- Any need to reopen auth, launcher, protocol, or bootstrap without fresh stronger evidence
- Two narrow hypotheses fail, or the blocker clearly moves outside selection -> map
- Any broad patch, helper rewrite, dependency swap, or old-project copy attempt

## Acceptance

- A populated account reaches the existing character selection screen in the rebuild
- Selecting an existing character lands on the map
- The proof bundle for that same run includes fresh `world.log` plus corroborating screenshots
- The sprint stops at map arrival and does not absorb adjacent systems

## Next narrow step after success

Plan the next pregame sprint as `populated account -> create via selection -> map`.
