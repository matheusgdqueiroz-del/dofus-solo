# AGENTS.md

## Mission
- Rebuild the Dofus solo/offline project safely from a clean foundation.
- Optimize in this order:
  1. Safety
  2. Easy rollback
  3. Evidence
  4. Minimum functional baseline
  5. Fidelity
  6. Speed

## Read this first
1. `AGENTS.md`
2. `docs/tracking/current-sprint.md`
3. `docs/resets/reset-pack.md`
4. `docs/tracking/decision-ledger.md`
5. `docs/tracking/evidence-index.jsonl`
6. `threads/thread_final.md`

## Permanent rules
- Treat `threads/thread_final.md` as the main historical source.
- Use threads 1 to 6 only when `thread_final.md` points back to them.
- Treat the old project in `N:\Codex_Programs\Dofus 2 private` as a reference source, not as a base to save.
- Never bulk-copy code, folder structures, or refactors from the old project.
- One primary bug per chat.
- One active sprint at a time.
- Main branch must stay green.
- Work only on a sprint branch.
- Create a checkpoint before and after any meaningful change.

## Evidence rules
- Trust order: payload/log/DB > screenshot > recollection.
- A screenshot is corroboration, not final proof by itself.
- A UI helper is a transport tool, not the final authority.
- Do not reopen auth/launcher/protocol/bootstrap areas without fresh evidence.

## Change rules
- Every change must be necessary, local, reversible, and low blast radius.
- No broad refactors.
- No dependency swaps without proven need.
- No architecture cleanup by initiative.
- No "general improvements."
- If two narrow hypotheses fail or the blocker changes, stop, checkpoint, update tracking, and start a fresh thread.

## Git and checkpoint rules
- Use `scripts/Start-Sprint.ps1` to create the sprint branch.
- Use `scripts/Save-Checkpoint.ps1` to save a checkpoint.
- Use `scripts/Restore-Checkpoint.ps1` to return safely from a tag into a new branch.
- Never use destructive Git recovery commands as the default path.

## Handoff protocol
- Every role response must end with a `NEXT PROMPT` handoff block.
- The handoff block must tell the user:
  - which role comes next
  - where to paste the next prompt
  - the full prompt in a copy-paste-ready fenced block
- Prefer a simple cyclic flow:
  - Planner -> Architect -> Orchestrator -> Writer -> Architect
- If a phase completes or a macro review is needed, use:
  - Writer -> Planner
- Do not end a role output with vague advice like "come back later" or "ask X to continue."
- End with an exact next prompt whenever possible.

## What to keep short
- `AGENTS.md` stays short and durable.
- Detailed planning lives in `docs/plans/`.
- Active work lives in `docs/tracking/current-sprint.md`.
- Reset context lives in `docs/resets/reset-pack.md`.
