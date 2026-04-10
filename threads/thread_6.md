# Notas de Rebuild - Escopo Desta Thread

## Escopo deste arquivo
- Este arquivo registra apenas o que foi descoberto, validado ou alterado nesta thread.
- Ele foi escrito depois da leitura de `thread_1.md`, `thread_2.md`, `thread_3.md`, `thread_4.md` e `thread_5.md` para evitar conflito.
- Portanto, ele nao reexplica:
  - host signature / patch inicial do SWF
  - `ServerId = 36`
  - o fechamento do pregame
  - a reancoragem estrutural `536 = Guided Tutorial` e `446 = Celestial Temple`
  - a fase anterior em que o NPC inicial do tutorial ja tinha sido tratado como visivel
- O foco aqui comeca depois do ponto em que a thread 5 terminou:
  - mapa inicial do guided tutorial ja existia
  - o NPC inicial ja nao devia mais ser tratado como "faltando" so por leitura visual
  - o proximo alvo real passou a ser empurrar o fluxo da quest/tutorial para frente

## Objetivo que esta thread perseguiu
- Tirar o guided tutorial do estado "mapa inicial existe, mas o fluxo nao anda".
- Fechar o maximo possivel do comeco jogavel do tutorial sem reabrir auth/launcher/bootstrap.
- Transformar o fluxo em algo mais fiel ao jogo real:
  - andar no mapa inicial
  - falar com o NPC
  - equipar o anel
  - trocar de mapa
  - entrar no primeiro combate
- Ao mesmo tempo, esta thread tambem tentou deixar o projeto mais barato de operar:
  - melhor classificacao de tela
  - melhor reducao de logs/token
  - painel de progresso local
  - disciplina de memoria e handoff

## Resultado real obtido nesta thread
- Esta thread avancou o tutorial muito alem da thread 5.
- Com evidencia real, o projeto passou por:
  - mapa inicial correto do tutorial
  - player e NPC visiveis separadamente
  - primeiro movimento do tutorial
  - dialogo com o `Npc 2897`
  - etapa do anel `Intrepid Ring`
  - primeira troca de mapa do tutorial
  - primeiro clique/aggro no `Globe Celeste`
  - inicio real da primeira luta
- O novo bloqueio final desta thread ficou estreito e claro:
  - a primeira luta ja comeca
  - mas o cliente cai/desconecta logo depois
  - a causa server-side ja foi provada como `NullReferenceException` em `SequenceManager.cs`
- Houve tambem um fechamento importante de processo:
  - esta thread mostrou na pratica que "um bug principal por chat" precisa virar regra dura
  - quando o bloqueio mudou, o custo de seguir em cascata ficou alto demais

## O que foi comprovado com evidencia

### 1. O payload do mapa inicial do guided tutorial estava correto
- Mapa alvo:
  - `152305664`
- Evidencia forte desta thread:
  - `MapComplementaryInformationsDataMessage` do mapa inicial provou `actorCount=2`
  - havia `1 character` e `1 npc`
  - o `Npc 2897` realmente entrava no payload
- Interpretacao correta:
  - o problema nao era mais "NPC inicial ausente"
  - o proximo passo deixou de ser spawn visual e passou a ser gameplay/progressao

### 2. O player estava sendo escondido pelo NPC e isso foi corrigido pelo overlay
- O bug visual real nao era ausencia do player no payload.
- O problema era de colocacao/celula: o NPC ficava perto demais da entrada e acabava escondendo o player.
- Arquivo importante da correcao:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.DbSync\OverlaySynchronizer.cs`
- Resultado observado nesta thread:
  - o overlay passou a evitar nao so a celula exata de entrada, mas tambem a vizinhanca imediata
  - o player ficou visivelmente separado do NPC
- Valor pratico para o rebuild:
  - em mapas tutoriais apertados, nao basta evitar a celula de spawn do player; precisa evitar a area imediata ao redor tambem

### 3. O clique sintetico no mapa inicial falhou varias vezes, mas isso nao provava bloqueio total de gameplay
- Esta thread testou varias tentativas estreitas de clique automatico no mapa inicial do tutorial.
- Em varias delas:
  - UI reagia
  - chat abria
  - mas o movimento no chao nao virava pacote de movimento
- O ponto importante e que depois ficou provado:
  - o problema nao podia ser tratado como "o jogo nao consegue andar nunca"
  - porque o usuario clicou manualmente e o personagem andou
- Conclusao assertiva para o rebuild:
  - falha de automacao de clique nao e prova suficiente de bug de gameplay
  - quando o teste depende de input humano/tempo de tela, o projeto precisa separar:
    - "o helper nao conseguiu"
    - "o jogo realmente nao aceita"

### 4. O tutorial realmente avancou depois do primeiro movimento
- Depois do clique manual do usuario no mapa inicial, o fluxo da quest passou a andar.
- A thread confirmou que o primeiro passo de movimento do tutorial nao era mais o bloqueio.
- Isso permitiu seguir para:
  - dialogo com o NPC
  - etapa do anel
  - primeira troca de mapa
- Licao pratica:
  - quando o usuario consegue produzir um delta que a automacao nao conseguiu, o projeto deve usar isso para estreitar a causa, e nao insistir na mesma hipotese de automacao

### 5. O `Npc 2897` e o dialogo inicial foram de fato parte do fluxo correto
- Esta thread seguiu o fluxo do tutorial com o `Npc 2897` como ancora real do inicio da quest.
- O dialogo apareceu e foi tratado como delta valido do tutorial.
- Isso reforcou a leitura correta do fluxo:
  - mapa inicial
  - conversa
  - anel
  - proxima sala
- Valor para o rebuild:
  - `Npc 2897` nao e decoracao; ele faz parte do caminho principal do tutorial

### 6. O item do tutorial foi ancorado como `10785 = Intrepid Ring`
- Esta thread confirmou o item do passo do anel como:
  - `ItemId = 10785`
  - nome: `Intrepid Ring`
- O tutorial passou pela etapa de equipar o anel.
- Porem, esta thread tambem deixou um lembrete importante do usuario:
  - em Dofus, equipar item nao e so "mover para slot"
  - precisa considerar efeitos, stats e possiveis bonus relacionados
- Consequencia correta para o rebuild:
  - passos de equipamento devem ser tratados como sistema de item/equip, nao so como animacao de UI

### 7. A primeira troca de mapa do tutorial precisou de alinhamento de protocolo
- A primeira troca de mapa foi bloqueada ate esta thread alinhar o pacote correto.
- Arquivo importante:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Protocol\Messages\Game\Context\Roleplay\ChangeMapMessage.cs`
- Achado importante:
  - `ChangeMapMessage.Id = 9495`
- Depois desse alinhamento, a troca de mapa deixou de ser desconhecida e o tutorial conseguiu seguir para a sala seguinte.
- Valor pratico:
  - quando um clique na borda gera caminhada mas nao gera transicao, olhar o pacote de mudanca de mapa antes de culpar o mapa inteiro

### 8. A primeira sala de combate do tutorial precisava ser fiel: um unico monstro, nao dois
- O usuario chamou atencao corretamente para um erro grave de fidelidade:
  - o primeiro combate do tutorial nao e contra dois monstros
  - primeiro vem um so, depois outra etapa e que cresce
- Esta thread tratou isso como bug real de experiencia de jogo, nao como detalhe cosmetico.
- Estado consolidado no fim:
  - `mapId = 152306688`
  - apenas um `Globe Celeste`
  - grupo curado `9400001`
  - sem duplicacao absurda de mobs e sem NPCs extras naquela sala
- Consequencia para o rebuild:
  - em tutorial e conteudo guiado, quantidade e colocacao de mobs importam muito
  - errar isso quebra a experiencia mesmo que "tecnicamente de para lutar"

### 9. O clique/agro no monstro do primeiro combate exigiu alinhamento de pacote e manifest
- Arquivo importante:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Protocol\Messages\Game\Context\Roleplay\Fight\GameRolePlayAttackMonsterRequestMessage.cs`
- Achado principal:
  - `GameRolePlayAttackMonsterRequestMessage.Id = 3188`
- Mas isso sozinho nao bastou.
- O tipo tambem precisava estar permitido em:
  - `N:\Codex_Programs\Dofus 2 private\runtime\protocol-id-manifest.txt`
- Esta foi uma licao importante desta thread:
  - quando o pacote continua unknown mesmo com `Id` certo, conferir o manifest antes de abrir investigacao maior

### 10. A primeira luta do tutorial realmente passou a comecar
- Depois do alinhamento do pacote de ataque ao monstro e do manifest, o servidor passou a receber o request de combate.
- Evidencias server-side provadas nesta thread:
  - `Received GameRolePlayAttackMonsterRequestMessage`
  - `Scripted PvM resolved characterId=6 mapId=152306688 groupId=9400001 questId=489`
  - `Send GameFightStartingMessage`
  - `Send GameFightJoinMessage`
  - `Send GameFightPlacementPossiblePositionsMessage`
  - objetivo de quest anterior foi concluido
- Estado de quest no fim desta fase:
  - `QuestId = 489`
  - `CurrentStepId = 1047`
  - objetivo pendente `3507`
- Interpretacao correta:
  - o bug "nao entra em combate" ficou fechado
  - o novo bug passou a ser o crash/disconnect logo depois do inicio da luta

### 11. O novo bug final ficou bem estreito: `NullReferenceException` em `SequenceManager`
- Arquivo do bug:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Fights\Synchronisation\SequenceManager.cs`
- Causa provada nesta thread:
  - `Fight.FighterPlaying` ainda podia estar `null`
  - `SequenceStartMessage(... sequence.Author.Id ...)` acabava estourando
- Correcao estreita aplicada nesta thread:
  - fallback de `Fight.FighterPlaying` para `Fight.GetFighters(false).FirstOrDefault()`
  - se continuar sem autor, logar e falhar de forma explicita
- Estado exato no fim da thread:
  - o patch ja estava aplicado
  - `Giny.World` ja tinha rebuildado limpo
  - mas o reteste dessa correcao ainda nao tinha acontecido
- Esse foi o ponto exato de handoff tecnico deixado por esta thread

### 12. O hover do monstro e o modulo de spells NAO ficaram resolvidos e nao devem ser tratados como "ok"
- O usuario apontou corretamente que:
  - no Dofus real, o hover do grupo de monstros mostra informacoes importantes como previsao de XP
  - isso nao estava funcionando direito
  - e o modulo de spells tambem nao devia ser assumido como ok
- Esta thread NAO fechou esses pontos.
- Regra correta para o rebuild:
  - nao supor que "combate esta resolvido" so porque o clique de agro ja entra na luta
  - o primeiro bug desta fase que ficou aberto no fim era a queda logo depois do inicio do combate
  - hover/spells ficaram explicitamente para a fase seguinte

## Ferramental e processo que esta thread adicionou e que valem reaproveitar

### 1. `Drive-DofusUi.ps1` ficou muito mais util para diagnostico real
- Esta thread ampliou bastante o helper:
  - `click-stage-relative`
  - `send_input`
  - `HoldMs`
  - screenshots before/after
  - `capture-diagnostic-snapshot`
  - start times de processos
  - `auth.log/world.log` freshness
- Valor para o rebuild:
  - esse helper deixou de ser apenas "clicar em coordenada"
  - ele virou ferramenta de classificacao de estado

### 2. Foi criada uma camada local de reducao de tokens em `runtime/distill/`
- Esta thread implementou:
  - `Setup-Distill.ps1`
  - `SmokeTest-Distill.ps1`
  - `Invoke-DistilledCommand.ps1`
  - `distill-profiles.json`
- Backend local escolhido:
  - `Ollama`
  - `qwen3.5:2b`
- Regra consolidada:
  - usar para saidas grandes nao interativas
  - nao usar para screenshot, bytes, query curta e linha literal de prova
- Licao importante:
  - o pacote publicado `@samuelfaj/distill` foi armadilha neste Windows
  - o caminho bom ficou sendo o wrapper local do repo

### 3. Foi criado um painel local de progresso em `runtime/progress-ui/`
- Esta thread implementou o painel local em:
  - `index.html`
  - `progress-model.js`
  - `progress-state.js`
  - `Open-ProgressDashboard.ps1`
- O painel foi pensado para:
  - ser visual
  - mostrar progresso do slice atual
  - mostrar escopos maiores do projeto
  - ser barato de atualizar
- Regra correta para o rebuild:
  - a manutencao normal do painel deve acontecer quase sempre so em `progress-state.js`

### 4. Esta thread consolidou regras de processo que valem mais do que varios patches
- Regras que surgiram como correcao de falhas reais desta thread:
  - um bug principal por chat
  - se o bloqueio mudou, checkpointar e encerrar
  - screenshot nao e prova unica
  - o usuario corrigindo leitura visual deve ser levado como verdade ate prova mais forte
  - nao confundir selecao com `blank forest`
  - janela preta expandida do chat nao e `blank forest`
  - falha do helper nao prova falha do jogo

### 5. Esta thread refez o `AGENTS.md` e gerou um prompt de handoff forte
- Arquivos criados/reestruturados:
  - `N:\Codex_Programs\Dofus 2 private\AGENTS.md`
  - `N:\Codex_Programs\Dofus 2 private\runtime\next-chat-handoff-prompt.md`
- O objetivo foi reduzir retrabalho futuro:
  - leitura minima viva
  - evidence hierarchy
  - one bug per chat
  - subsystem preflight
- Para o rebuild novo, a ideia importante aqui nao e "copiar o texto literalmente", e sim preservar o principio:
  - memoria viva curta
  - agentes com guardrails curtos
  - handoff forte entre chats

## Arquivos mais importantes tocados por esta thread
- Guided tutorial / overlay / mapa:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.DbSync\OverlaySynchronizer.cs`
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Progression\GuidedTutorialManager.cs`
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Maps\Instances\MapInstance.cs`
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Maps\Instances\ClassicMapInstance.cs`
- Protocol / map change / combat aggro:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Protocol\Messages\Game\Context\Roleplay\ChangeMapMessage.cs`
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Protocol\Messages\Game\Context\Roleplay\Fight\GameRolePlayAttackMonsterRequestMessage.cs`
  - `N:\Codex_Programs\Dofus 2 private\runtime\protocol-id-manifest.txt`
- Combate:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Fights\Synchronisation\SequenceManager.cs`
- Helper/processo:
  - `N:\Codex_Programs\Dofus 2 private\runtime\Drive-DofusUi.ps1`
  - `N:\Codex_Programs\Dofus 2 private\runtime\distill\Setup-Distill.ps1`
  - `N:\Codex_Programs\Dofus 2 private\runtime\distill\Invoke-DistilledCommand.ps1`
  - `N:\Codex_Programs\Dofus 2 private\runtime\progress-ui\index.html`
  - `N:\Codex_Programs\Dofus 2 private\runtime\progress-ui\progress-model.js`
  - `N:\Codex_Programs\Dofus 2 private\runtime\progress-ui\progress-state.js`
  - `N:\Codex_Programs\Dofus 2 private\AGENTS.md`
  - `N:\Codex_Programs\Dofus 2 private\runtime\next-chat-handoff-prompt.md`

## Fontes externas que esta thread consolidou
- Esta thread reforcou e repetiu a politica:
  - `Dofus Pour Les Noobs` como ancora humana principal para quests e fluxo
  - sempre cruzando com ids/mapas/NPCs locais antes de patchar
  - `DofusDB` apenas sidecar/manual
- Paginas do tutorial inicial que ficaram como ancora util:
  - `https://www.dofuspourlesnoobs.com/bien-debuter.html`
  - `https://www.dofuspourlesnoobs.com/vaincre-les-monstres.html`
  - `https://www.dofuspourlesnoobs.com/l-anneau-de-tous-les-dangers.html`

## O que deu certo e vale repetir no rebuild

### 1. Tratar tutorial como gameplay de verdade, nao como um monte de micro patches isolados
- Esta thread andou quando olhou o fluxo:
  - movimento
  - dialogo
  - item
  - troca de mapa
  - agro
  - combate
- Esse raciocinio e melhor do que "fazer um clique funcionar" sem olhar o resto

### 2. Confiar no primeiro delta real, nao na intuicao visual
- Exemplos fortes desta thread:
  - payload correto do mapa inicial
  - player escondido pelo NPC, nao ausente
  - helper falhando em mover nao provou que o jogador nao podia mover
  - pacote de ataque certo precisou de manifest tambem

### 3. Usar correcoes estreitas com prova forte
- Os melhores ganhos desta thread foram estreitos:
  - afastar o NPC da entrada do player
  - alinhar `ChangeMapMessage`
  - alinhar `GameRolePlayAttackMonsterRequestMessage`
  - corrigir o manifest
  - fallback estreito em `SequenceManager`

### 4. Registrar traps de processo no proprio repo
- As melhores melhorias desta thread nao foram so de gameplay.
- Foram tambem:
  - distill local
  - painel de progresso
  - AGENTS curto com guardrails
  - handoff forte
- Isso ajuda o rebuild novo a nao gastar horas repetindo erro de metodo

### 5. Quando o usuario fornece um delta real, usar isso para estreitar a causa
- O clique manual do usuario no mapa e no fluxo do tutorial foi decisivo.
- Em vez de tratar isso como "excecao", o projeto deve absorver esse delta como prova e seguir a partir dele

## Armadilhas para evitar no rebuild

### 1. Nao tratar falha de automacao como prova de falha de jogo
- Esta thread mostrou isso varias vezes.
- O helper falhou em alguns cliques de gameplay enquanto o usuario conseguia produzir o delta manualmente.

### 2. Nao seguir em cascata corrigindo 4 bugs de combate no mesmo chat
- Este foi um erro real desta thread.
- O custo subiu demais quando o bloqueio mudou e a thread continuou aberta.
- A regra correta ficou:
  - mudou o bug principal
  - checkpoint
  - atualiza memoria e progresso
  - abre outra thread

### 3. Nao assumir que "entrou na luta" significa combate saudavel
- Hover de monstro
- spells
- fluxo de turno
- rewards
- tudo isso ainda precisa de preflight proprio
- O fato de o combate comecar so fecha o agro/inicio, nao o sistema inteiro

### 4. Nao esquecer que o manifest pode ser a peca faltante
- Esta thread voltou a provar isso.
- `Id` correto no source sem liberacao no manifest continua gerando comportamento enganoso

### 5. Nao deixar o projeto depender do usuario estar olhando a tela o tempo todo
- Esta thread sofreu com isso em runs manuais.
- O rebuild novo deve preferir:
  - snapshots diagnosticos
  - helpers que classificam estado
  - menos janelas de tempo que exigem reacao instantanea do usuario

### 6. Nao perder a fidelidade do tutorial
- O usuario apontou corretamente:
  - numero de monstros errado quebra a experiencia
  - colocacao errada tambem quebra
- O rebuild deve tratar fidelidade como requisito, nao polimento

## Estado final exato desta thread
- Processos do jogo estavam encerrados quando o handoff foi preparado.
- Conta de teste principal:
  - `solo2 / solo2`
- Personagem principal desta fase:
  - `characterId = 6`
  - `Soloradwm`
- Estado de quest no fim:
  - `QuestId = 489`
  - `CurrentStepId = 1047`
  - objetivo pendente `3507`
- O fluxo do tutorial ja tinha passado por:
  - movimento inicial
  - dialogo com `Npc 2897`
  - anel
  - primeira troca de mapa
  - primeiro agro no `Globe Celeste`
- O novo bloqueio final era:
  - primeira luta comeca
  - servidor entra no combate
  - depois vem disconnect/crash
  - causa provada: `NullReferenceException` em `SequenceManager.cs`
- O patch estreito desse bug ja tinha sido aplicado e buildado, mas ainda nao retestado

## Proximo passo recomendado se for reconstruir esta linha de trabalho
1. Recriar primeiro a linha de progresso ate o guided tutorial ficar no mapa inicial correto.
2. Confirmar por payload/log que o mapa inicial tem player + `Npc 2897`, e nao depender so de screenshot.
3. Reaplicar o afastamento do NPC em relacao a entrada do player.
4. Revalidar o fluxo do tutorial nesta ordem:
   - movimento inicial
   - dialogo com o NPC
   - etapa do `Intrepid Ring`
   - troca de mapa
   - sala do primeiro `Globe Celeste`
5. Antes de atacar combate no rebuild, fazer um preflight curto do subsistema:
   - hover
   - dados do grupo
   - spells basicos
   - placement/start
   - rewards/quest delta
6. Reaplicar o alinhamento:
   - `ChangeMapMessage.Id = 9495`
   - `GameRolePlayAttackMonsterRequestMessage.Id = 3188`
   - entrada correspondente em `protocol-id-manifest.txt`
7. So depois retestar o primeiro clique de agro.
8. Quando a luta voltar a comecar, verificar imediatamente o bug seguinte:
   - `SequenceManager`
   - fallback de `Fight.FighterPlaying`
9. Se esse patch estabilizar o inicio da luta, parar e abrir a proxima thread para hover/spells/combate em si.

## Resumo curto para merge futuro
- Esta thread foi a transicao de "tutorial anda um pouco" para "tutorial entra de verdade na primeira luta".
- O que ela fechou com mais valor para o rebuild foi:
  - payload inicial do mapa correto
  - correcao de player escondido pelo NPC
  - progresso real do tutorial ate a primeira troca de mapa
  - fidelidade da primeira sala de combate para um unico `Globe Celeste`
  - alinhamento de `ChangeMapMessage` e `GameRolePlayAttackMonsterRequestMessage`
  - necessidade de liberar o tipo tambem no `protocol-id-manifest.txt`
  - primeira luta finalmente comecando
  - bug final estreito em `SequenceManager.cs`
- Do lado de processo, esta thread tambem deixou 4 herancas importantes para o rebuild:
  - `distill` local para logs grandes
  - painel de progresso local
  - `AGENTS.md` curto com guardrails fortes
  - regra dura de um bug principal por chat
