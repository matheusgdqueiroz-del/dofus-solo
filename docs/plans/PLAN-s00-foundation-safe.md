# PLAN S00 - Foundation Safe

## Summary

Install the process foundation of the new rebuild repo without touching gameplay code.

## Deliverables

- Git repo initialized and aligned with GitHub
- Branch model in place
- Durable guardrails in `AGENTS.md`
- Tracking docs
- Reset pack
- Checkpoint and rollback scripts

## Constraints

- No gameplay implementation
- No old-project bulk import
- No large binary/client files
- No broad structural changes outside repo bootstrap

## Acceptance

- The repo can create a sprint branch
- The repo can save a checkpoint
- The repo can restore from a checkpoint tag into a safe new branch
- The core docs explain how to continue without reopening old chaos
