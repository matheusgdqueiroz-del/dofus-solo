# Current Sprint

- Date: 2026-04-09
- Sprint: `S00 - Foundation Safe`
- Status: `completed`
- Branch: `work/s00-foundation-safe`

## Goal

Create the safe foundation of the new rebuild repo without touching gameplay code.

## In scope

- Initialize the new Git repository.
- Add durable guardrails in `AGENTS.md`.
- Add minimal tracking docs.
- Add simple checkpoint and rollback scripts.
- Keep `threads/` as historical memory.

## Out of scope

- Port gameplay code.
- Rebuild launcher/auth/world logic.
- Copy large parts of the old project.
- Fix any game bug.

## Success criteria

- Repo is under Git and linked to GitHub.
- Sprint docs exist.
- Checkpoint workflow exists through scripts.
- Reset pack exists.
- Rules against broad refactors are documented.
- Copy-paste handoff workflow exists and is documented.

## Allowed paths

- `README.md`
- `AGENTS.md`
- `docs/**`
- `scripts/**`
- `threads/**`

## Prohibited paths

- Any gameplay or runtime code from the old project.
- Any large binary/client asset import.

## Current blocker

None. Sprint 0 foundation work is complete.

## Next narrow step

Start Sprint 1 and fill the baseline matrix using `threads/thread_final.md` as the primary source.
