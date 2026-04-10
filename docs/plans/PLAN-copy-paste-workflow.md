# PLAN - Copy Paste Workflow

## Summary

Make the workflow dead simple for the user:

- every thread must end with the next prompt
- the next prompt must say where to paste it
- the user should not need to reason about the orchestration loop

## Changes

- Add a durable handoff rule to `AGENTS.md`
- Add a short operational guide for the copy-paste cycle
- Add ready-to-use prompt templates for Planner, Architect, Orchestrator, Writer, and Planner Review

## Acceptance

- The repo contains a clear `copy-paste-workflow` guide
- The repo contains prompt templates for each role
- The durable agent rules require a final handoff block
