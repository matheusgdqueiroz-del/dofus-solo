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

## 2026-04-09 - Workflow must be copy-paste driven for the user
- Decision: every role output must end with the next prompt and where to paste it.
- Why: the user wants a cyclic workflow with minimal operational thinking and no ambiguity between roles.

## 2026-04-10 - Sprint 1 is documentation-only
- Decision: Sprint 1 is limited to baseline audit, planning, and tracking updates.
- Why: the rebuild still needs a safe intake boundary before any gameplay implementation begins.

## 2026-04-10 - Safe initial baseline is populated account to map
- Decision: the first rebuild baseline is `populated account -> existing character selection -> map`.
- Why: it is the smallest already-proven slice with the lowest risk and does not force tutorial, quest, or combat complexity into the first implementation sprint.

## 2026-04-10 - Old project remains reference-only during Sprint 1
- Decision: `N:\Codex_Programs\Dofus 2 private` remains reference-only and cannot be used as a code base for Sprint 1.
- Why: Sprint 1 is about safe intake, not rescue, and the old project is still a contamination risk.

## 2026-04-10 - First implementation sprint is existing character to map only
- Decision: the first implementation sprint is limited to `populated account -> existing character selection -> map`.
- Why: it is the smallest proven pregame slice and avoids dragging empty-account, quest, tutorial, or combat complexity into the first implementation pass.

## 2026-04-10 - Success proof for the first implementation sprint must be log-first
- Decision: success for the first implementation sprint must be proven by a fresh real-user run with fresh `world.log`, with screenshots used only as corroboration.
- Why: screenshot alone is not strong enough proof for pregame state, and harness-only proof is not enough for the rebuild baseline.

## 2026-04-10 - Next adjacent pregame slice stays create-via-selection
- Decision: after success on existing-character selection to map, the next narrow pregame slice should be `populated account -> create via selection -> map`.
- Why: it stays inside the same populated-account selection surface and is narrower than reopening the empty-account path.

## 2026-04-10 - Sprint 2 must be formally reclassified before gameplay resumes
- Decision: Sprint 2 must not continue as `existing character selection -> map` yet; it must first be reclassified into a minimal executable-surface sprint on the same branch family.
- Why: the current repo still has no runtime, client, server, launcher, harness, or log path, so the active blocker sits before the intended gameplay slice and cannot be solved by narrow pregame work.
