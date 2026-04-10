# Baseline Matrix

Use this file in Sprint 1 to classify what the rebuild should do with each important area.

| Area | Source | Current status | Rebuild action | Notes |
|---|---|---|---|---|
| Evidence model | `threads/thread_final.md` | Closed | Carry forward now | `payload/log/DB > screenshot > recollection` |
| Historical source | `threads/thread_final.md` | Closed | Carry forward now | Use threads 1 to 6 only when `thread_final.md` points back to them |
| Pregame constants | `threads/thread_final.md` | Closed | Carry forward now | `ServerId = 36` and `7121 = ServerSelectionMessage` |
| Client patch strategy | `threads/thread_final.md` | Closed | Carry forward now | Minimal patch only; prefer deterministic `patch-state`; no blind repatch |
| Progress tracking model | `threads/thread_final.md` | Closed | Carry forward now | Keep tracker conservative and separate current slice from global progress |
| Executable rebuild surface | Repo tree scan + `docs/tracking/evidence-index.jsonl` | Missing | Rebuild first | Minimal runnable surface must exist before any fresh pregame proof is possible |
| Safe initial baseline | `threads/thread_final.md` | Proven | Rebuild first | Real user flow only; populated account -> existing character selection -> map; stop at first map load |
| Empty-account creation flow | `threads/thread_final.md` | Proven | Revalidate later | Outside Sprint 1 |
| Create-via-selection flow | `threads/thread_final.md` | Proven | Revalidate later | Outside Sprint 1 |
| Incarnam normal quest baseline | `threads/thread_final.md` | Useful but revalidate | Revalidate later | Future normal quest anchor is `1632 Le village dans les nuages` |
| Guided Tutorial special flow | `threads/thread_final.md` | Special and deferred | Revalidate later | Do not use as the first baseline |
| Tutorial quest `489` | `threads/thread_final.md` | Special and deferred | Revalidate later | Do not treat like a normal Incarnam quest |
| Combat first fight | `threads/thread_final.md` | Useful but revalidate | Revalidate later | Outside Sprint 1 |
| Auth/launcher/protocol/bootstrap reopen | `threads/thread_final.md` | Closed without fresh evidence | Reference only | Do not reopen without new payload, log, or DB proof |
| Old project code and structure | `N:\Codex_Programs\Dofus 2 private` | Failed reference | Reference only | No bulk copy and no attempt to save the old project |
