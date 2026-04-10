# dofus-solo

Rebuild seguro do projeto Dofus solo/offline.

## Estado atual

- Este repositório novo vive em `N:\Codex_Programs\Dofus 2 private_2`.
- O projeto antigo continua em `N:\Codex_Programs\Dofus 2 private` apenas como fonte de evidência e referência.
- A pasta `threads/` guarda o histórico condensado do projeto antigo.
- `threads/thread_final.md` é a principal fonte histórica.

## Objetivo

Recuperar primeiro o baseline mínimo funcional com o menor risco possível:

1. jogo abre
2. login funciona
3. seleção/criação funciona
4. entra no mapa
5. NPC aparece
6. quest abre

Só depois disso o projeto continua evoluindo.

## Fluxo simples de trabalho

1. Criar a branch da sprint:

```powershell
.\scripts\Start-Sprint.ps1 -SprintNumber 0 -Slug foundation-safe
```

2. Trabalhar apenas no escopo da sprint atual.

3. Salvar checkpoint:

```powershell
.\scripts\Save-Checkpoint.ps1 -Summary "foundation docs and scripts"
```

4. Se algo der ruim, listar tags e restaurar:

```powershell
.\scripts\Restore-Checkpoint.ps1
.\scripts\Restore-Checkpoint.ps1 -Tag cp-20260409-1930-s00-foundation-docs
```

## Estrutura

- `AGENTS.md`: regras duráveis para qualquer agente.
- `docs/tracking/current-sprint.md`: sprint ativa.
- `docs/resets/reset-pack.md`: resumo curto para reset.
- `docs/ops/checkpoints-and-rollback.md`: manual operacional simples.
- `docs/ops/copy-paste-workflow.md`: manual do ciclo de copiar e colar.
- `docs/plans/`: planos detalhados por tema.
- `prompts/`: prompts prontos para cada papel.
- `threads/`: memória histórica do projeto antigo.

## Se voce quer o caminho mais simples

Abra:

- `prompts/00-START-HERE.md`

Esse arquivo diz qual prompt copiar primeiro.

## Regra de ouro

Este rebuild não existe para "salvar o projeto antigo". Ele existe para começar de novo, com processo mais seguro, mais reversível e mais limpo.
