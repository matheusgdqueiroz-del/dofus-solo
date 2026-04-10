# PLAN S01 - Baseline Audit Safe

## Summary

Define, in writing, what the new rebuild should carry forward now, what needs later revalidation, and what stays reference-only from the old project.

## Deliverables

- `docs/tracking/current-sprint.md` updated for Sprint 1
- `docs/tracking/baseline-matrix.md` expanded with clear classes
- `docs/tracking/decision-ledger.md` updated with Sprint 1 decisions
- `docs/resets/reset-pack.md` aligned with the active sprint branch

## Constraints

- Documentation and tracking only
- No gameplay implementation
- No broad refactor
- No bulk copy from the old project
- No runtime, client, server, launcher, auth, protocol, or bootstrap edits

## Risks

- The old project contaminates rebuild decisions if treated like a base
- Scope grows into gameplay or tutorial work before the baseline is locked
- Closed areas get reopened without fresh evidence
- Screenshot-based recollection overrides stronger evidence from logs, payloads, or DB data

## Rollback triggers

- Any change outside planning, tracking, or reset docs
- Any attempt to pull tutorial, combat, or quest work into this sprint
- Any Sprint 1 decision that conflicts with `threads/thread_final.md` without fresh evidence
- Any unexpected working tree changes unrelated to the documentation scope

## Acceptance

- The safest initial baseline is locked as populated account -> existing character selection -> map
- The baseline matrix has no ambiguous `maybe` classification
- The old project is documented as reference-only
- No files outside the approved documentation scope are changed
