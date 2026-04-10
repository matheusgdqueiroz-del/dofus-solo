# Decision Ledger

## 2026-04-09 - New rebuild repo lives in `Dofus 2 private_2`
- Decision: the new rebuild starts in `N:\Codex_Programs\Dofus 2 private_2`.
- Why: it keeps the failed project isolated and reduces contamination risk.

## 2026-04-09 - Old project is reference-only
- Decision: `N:\Codex_Programs\Dofus 2 private` is a historical and technical reference, not the base to save.
- Why: the old project suffered a large unsafe refactor and cannot be trusted as a clean baseline.

## 2026-04-09 - `thread_final.md` is the primary historical source
- Decision: `threads/thread_final.md` is the default historical source for planning and recovery.
- Why: it already merges the useful conclusions from threads 1 to 6 and marks what is closed versus what must be revalidated.

## 2026-04-09 - Main stays green
- Decision: all work happens on sprint branches; `main` is reserved for stable states.
- Why: this makes rollback easier for a novice user and lowers the chance of losing a known-good point.

## 2026-04-09 - Checkpoint workflow must be script-driven
- Decision: checkpoint and rollback are implemented through PowerShell scripts instead of manual Git command sequences.
- Why: this is simpler, safer, and more repeatable for a novice user.

## 2026-04-09 - Sprint 0 is process-only
- Decision: Sprint 0 is limited to repo, docs, and safety tooling.
- Why: this creates a safe base before any gameplay work and prevents early contamination from the old failed project.
