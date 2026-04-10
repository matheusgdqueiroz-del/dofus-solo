# Checkpoints and Rollback

## Purpose

This file explains the safe Git flow in plain language.

## Rule of thumb

- A checkpoint is a safe photo of the project.
- Save a checkpoint before risky work and after a real validated gain.
- If something breaks, return from the last good checkpoint into a new branch.

## When to save a checkpoint

- Before starting a sprint
- Before a risky change
- After a validated improvement
- When the main bug changes
- Before any rollback attempt

## Before saving

Make sure you have:

- a short summary sentence
- the sprint branch active
- the result of the last test
- no confusion about what changed

## Start a sprint branch

```powershell
.\scripts\Start-Sprint.ps1 -SprintNumber 2 -Slug pregame-minimo
```

This creates a branch like:

- `work/s02-pregame-minimo`

## Save a checkpoint

```powershell
.\scripts\Save-Checkpoint.ps1 -Summary "pregame minimum validated"
```

What this does:

1. stages changes
2. creates a commit
3. creates a tag like `cp-20260409-1930-s02-pregame-minimum-validated`
4. pushes the branch and tag to GitHub

## See available checkpoints

```powershell
.\scripts\Restore-Checkpoint.ps1
```

## Return to a checkpoint

```powershell
.\scripts\Restore-Checkpoint.ps1 -Tag cp-20260409-1930-s02-pregame-minimum-validated
```

What this does:

1. fetches tags
2. creates a new branch from that tag
3. keeps the broken branch untouched

## Hard prohibitions

- Do not use `git reset --hard` as your normal recovery path.
- Do not work directly on `main`.
- Do not overwrite a broken branch by force if you still need the evidence from it.
