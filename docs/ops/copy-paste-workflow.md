# Workflow de Copiar e Colar

## Objetivo

Este arquivo existe para deixar o processo o mais simples possivel para voce.

Regra principal:

- voce abre a thread do papel certo
- cola o prompt indicado
- espera a resposta
- no fim da resposta, copia o bloco `PROXIMO PAPEL`
- cola esse proximo prompt no papel indicado

Voce nao precisa improvisar o fluxo.

## Ordem normal do ciclo

1. `Planner`
2. `Architect`
3. `Orchestrator`
4. `Writer/Organizer`
5. volta para `Architect`

Quando usar `Planner` de novo:

- fim de fase macro
- rollback importante
- desvio de visao
- duvida sobre direcao do projeto

## Regra obrigatoria de saida

Toda resposta de papel deve terminar com este formato:

```text
PROXIMO PAPEL: <nome do papel>
ONDE COLAR: <nova thread ou thread existente do papel>
ACAO ANTES DE COLAR: <se nao houver, escrever NENHUMA>

PROMPT:
<prompt completo pronto para copiar e colar>
```

## Seu uso pratico

- Se a resposta ja terminou com `PROXIMO PAPEL`, voce nao decide nada.
- Voce so copia o bloco final e cola onde foi mandado.
- Se a resposta nao terminar com esse bloco, considere a resposta incompleta.

## Atalhos mentais

- `Planner` decide a direcao.
- `Architect` corta em sprint.
- `Orchestrator` executa a sprint.
- `Writer` resume e prepara reset.

## Quando parar

Pare e volte ao `Planner` se:

- um rollback importante aconteceu
- a sprint mudou de objetivo
- apareceu conflito serio entre historico e estado atual
- alguem comecou a abrir escopo demais
