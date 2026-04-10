# Thread 7 - Merge Inteligente Para O Novo Planner

## Como usar este arquivo
- Este arquivo e o documento mestre do `Planner` para o rebuild novo.
- Ele nao e cronologia bruta. Ele junta o que ficou realmente provado nas threads anteriores e nos checkpoints validos reaproveitaveis para o novo projeto.
- Papel deste arquivo:
  - dar mapa mental do projeto
  - evitar releitura de todas as threads toda hora.
  - apontar em que thread abrir detalhe quando necessario

### Provas mais fortes
- `thread_1.md` a `thread_6.md`

### Arquivos/artefatos para abrir se precisar aprofundar
- `N:\Codex_Programs\Dofus 2 private_2\thread_1.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_2.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_3.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_4.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_5.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_6.md`

## Linha do tempo curta do que realmente ficou provado
- `Fechado`: o primeiro bloqueio serio foi `host signature`, nao launcher invisivel. O cliente abria, mas rejeitava o host local.
- `Fechado`: o caminho pregame correto ficou:
  - `ServerId = 36`
  - `7121 = ServerSelectionMessage`
  - fluxo simples `Abrir Dofus Solo.cmd -> Jogar Agora`
- `Fechado`: conta vazia conseguiu fazer:
  - criacao
  - loading
  - mapa
  - movimento
- `Fechado`: conta populada conseguiu fazer:
  - abrir na selecao
  - selecionar personagem existente -> mapa
  - criar pela selecao -> mapa
- `Fechado`: o inicio real do jogo nao deve ser tratado como bloco unico:
  - `subarea 536 = Guided Tutorial`
  - `subarea 446 = Celestial Temple`
- `Fechado`: o client 2.63.9.16 ja fornece muito catalogo canonico; isso deve ser fonte principal para ids, textos e estrutura.
- `Fechado`: o guided tutorial avancou ate:
  - movimento inicial
  - dialogo com `Npc 2897`
  - `Intrepid Ring`
  - primeira troca de mapa
  - primeiro agro no `Globe Celeste`
  - inicio real da primeira luta
- `Util, mas revalidar`: a primeira luta do tutorial deixou de travar apenas em `SequenceManager`; ela avancou ate placement e depois ate primeiro turno sob workaround estreito. O disconnect passou a ficar associado a uma familia posterior, especialmente `GameFightUpdateTeamMessage`.
- `Util, mas revalidar`: o problema de spells deixou de ser "nao aparecem nunca"; elas chegaram a aparecer, e o bug remanescente virou o rotulo cosmetico `Alternative Word (13171)`, que foi explicitamente adiado.
- `Fechado`: o tracker antigo inflava o progresso; o modelo correto para o novo projeto precisa ser conservador, com escopos ponderados e `currentSlice` separado do global.
- `Fechado`: no tutorial, `QuestId = 489` e especial e auto-iniciada. O journal/tracker ali nao deve ser tratado como quest comum.
- `Util, mas revalidar`: o pivot certo para provar sistema basico de missao sem a complexidade do tutorial passou a ser Incarnam pos-templo, com `1632 Le village dans les nuages`.

### Provas mais fortes
- `thread_1.md`: host signature
- `thread_2.md`, `thread_3.md`, `thread_4.md`: fechamento do pregame
- `thread_5.md`, `thread_6.md`: tutorial estruturado

### Arquivos/artefatos para abrir se precisar aprofundar
- `N:\Codex_Programs\Dofus 2 private_2\thread_4.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_5.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_6.md`

### O que nao reabrir sem evidencia nova
- A ideia de que o projeto "nao sai do launcher".
- A ideia de que a primeira luta do tutorial ainda morre apenas por causa do `NullReferenceException` original de `SequenceManager`.

## Tudo que voce deve saber sobre blank forest e leitura visual
- `Fechado`: `blank forest` e sintoma visual, nao causa raiz.
- `Fechado`: screenshot sozinho **nao** prova ausencia de ator, quest, NPC, tela de selecao, nem sucesso de UI.
- `Fechado`: o usuario corrigindo leitura visual vale mais do que a interpretacao do modelo ate surgir prova mais forte.
- `Fechado`: `CharactersListMessage` no backend **nao** significa que a selecao esta visivel na tela.
- `Fechado`: tela preta/chat expandido tambem nao deve ser confundido automaticamente com `blank forest`.
- `Fechado`: classificacao de tela estranha deve usar esta ordem:
  - start times frescos de `Dofus/Auth/World`
  - `auth.log` e `world.log` com last-write fresco
  - snapshot diagnostico
  - so depois leitura visual
- `Util, mas revalidar`: em varias fases do projeto, automacao de screenshot e clique falhou enquanto o usuario conseguia produzir o delta manualmente. Isso prova que helper falho e diferente de gameplay falho.
- `Util, mas revalidar`: na fase de missoes do tutorial, a sidebar apareceu e sumiu em timings diferentes. O erro ali nao podia ser fechado por screenshot instantaneo; precisava de checks atrasados e log.

### Provas mais fortes
- `thread_5.md`: correcao do usuario sobre screenshot do NPC inicial
- `thread_6.md`: regra forte de screenshot como corroboracao, nao prova primaria

### Arquivos/artefatos para abrir se precisar aprofundar
- `N:\Codex_Programs\Dofus 2 private_2\thread_5.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_6.md`

### O que nao reabrir sem evidencia nova
- Qualquer classificacao visual forte baseada em um unico print.
- A equivalencia `CharactersList backend = tela de selecao carregada`.

## Tudo que voce deve saber sobre launcher, auth, serverId e tela de selecao
- `Fechado`: o primeiro bloqueio serio foi o cliente rejeitando o host local por assinatura, nao o auth local em si.
- `Fechado`: mudar so `connection.host` para localhost nao bastava; a assinatura antiga continuava bloqueando o cliente.
- `Fechado`: o ponto exato da falha foi localizado em `AuthentificationFrame.pcode` dentro de `DofusInvoker.swf`.
- `Fechado`: `ServerId = 36` foi um alinhamento importante porque o client 2.63 nao conhecia o valor local antigo `1`.
- `Fechado`: `7121 = ServerSelectionMessage`, nao `CharacterSelectionMessage`.
- `Fechado`: o botao `Jogar Agora` e o `LaunchHarness start-game` passam pelo mesmo `SoloLauncherService.StartGameAsync(settings)`. Eles nao devem ser tratados como launchers conceitualmente diferentes.
- `Fechado`: a validacao por `patch-state` e melhor do que repatch cego do SWF vivo.
- `Util, mas revalidar`: manter uma conta limpa separada da conta `admin` ajudou muito a isolar o fluxo real do jogador e evitar ruido de selecao+criacao.
- `Util, mas revalidar`: o patch de auto-selecao do servidor local reduziu bastante atrito, mas continua sendo algo que o rebuild deve reaplicar na menor escala possivel.

### Provas mais fortes
- `thread_1.md`: `host signature` em `AuthentificationFrame.pcode`
- `thread_2.md`: `ServerId = 36`, `7121 = ServerSelectionMessage`
- `thread_3.md` e `thread_4.md`: mesmo caminho de launch entre `Jogar Agora` e `LaunchHarness`

### Arquivos/artefatos para abrir se precisar aprofundar
- `N:\Codex_Programs\Dofus 2 private_2\thread_1.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_2.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_3.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_4.md`

### O que nao reabrir sem evidencia nova
- Auth/token parsing como foco primario depois que o cliente ja passou do popup de host e chega a tela de personagem.
- Teorias de "harness e botao sao launchers diferentes".

## Tudo que voce deve saber sobre criacao, selecao e entrada no mapa
- `Fechado`: conta vazia -> criacao -> loading -> mapa -> movimento foi provado.
- `Fechado`: conta populada -> selecao -> mapa foi provado.
- `Fechado`: conta populada -> criar novo personagem pela selecao -> mapa foi provado.
- `Fechado`: o pos-criacao e bug diferente da criacao em si. O request de criacao chegou e validou antes do proximo bloqueio.
- `Fechado`: `HandleCharacterFirstSelectionMessage(...)` tinha bug real e precisou deixar de devolver erro hardcoded para o primeiro personagem.
- `Fechado`: o primeiro personagem de conta vazia precisou de fallback estreito de auto-selecao apos `SendCharactersList()`.
- `Fechado`: o unknown `7066` precisou ser tratado como bootstrap pos-selecao/contexto.
- `Fechado`: `LaunchHarness` usa binarios compilados; editar `.cs` sem rebuild gera falso negativo.
- `Util, mas revalidar`: o pregame foi conceitualmente fechado e o usuario chegou a confirmar manualmente que funcionou. Mesmo assim, o rebuild novo deve reprovar o fluxo simples real do usuario, nao so o harness.
- `Util, mas revalidar`: continuar usando screenshot + `world.log` como dupla minima de prova para qualquer etapa de pregame.

### Provas mais fortes
- `thread_3.md`: conta vazia, loading, mapa e movimento
- `thread_4.md`: conta populada -> selecao -> mapa; criar pela selecao -> mapa; regressao de conta vazia revalidada

### Arquivos/artefatos para abrir se precisar aprofundar
- `N:\Codex_Programs\Dofus 2 private_2\thread_3.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_4.md`

### O que nao reabrir sem evidencia nova
- Auth/launcher como culpado primario depois que `world.log` ja mostra:
  - `CharacterCreationRequestMessage`
  - `CharacterSelectedSuccess`
  - bootstrap de contexto/mapa
- Mudancas amplas de automacao antes do primeiro delta real.

## Tudo que voce deve saber sobre guided tutorial / Celestial Temple / Incarnam
- `Fechado`: `subarea 536 = Guided Tutorial`.
- `Fechado`: `subarea 446 = Celestial Temple`.
- `Fechado`: essas duas fases nao devem ser costuradas como se fossem a mesma coisa.
- `Fechado`: o client 2.63 ja traz muito catalogo canonico; isso deve ser a base do rebuild novo.
- `Fechado`: `154010883` nao deve ser forcado como mapa de combate; ele foi provado como mapa errado para esse papel.
- `Fechado`: o mapa inicial correto do guided tutorial era `152305664`.
- `Fechado`: `MapComplementaryInformationsDataMessage` desse mapa provou `1 character + 1 npc`, inclusive `Npc 2897`.
- `Fechado`: em mapas especiais do tutorial, `Blue/Red = 0/0` nao e prova suficiente de "sem combate".
- `Fechado`: o tutorial precisou de pipeline/runtime proprio; ele nao se comporta como quest normal solta.
- `Util, mas revalidar`: o rebuild deve seedar cedo:
  - memoria curta
  - ledger
  - evidence index
  - gates por fase
- `Util, mas revalidar`: depois do acerto de missoes/journal no tutorial, o pivot melhor para provar sistema basico de quest passou a ser Incarnam pos-templo com `1632`, porque o tutorial adiciona camadas demais.
- `Util, mas revalidar`: no baseline de Incarnam, o alvo certo para provar o fluxo normal de missao passou a ser `1632 Le village dans les nuages`, com `Lykhen` como ancora humana cruzada com ids locais.

### Provas mais fortes
- `thread_5.md`: reancoragem estrutural `536` vs `446`, catalogo canonico, mapa alvo correto
- `thread_6.md`: payload do mapa inicial do tutorial, progresso real do fluxo

### Arquivos/artefatos para abrir se precisar aprofundar
- `N:\Codex_Programs\Dofus 2 private_2\thread_5.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_6.md`

### O que nao reabrir sem evidencia nova
- A ideia de que `Guided Tutorial` e `Celestial Temple` sao uma fase so.
- O impulso de usar o tutorial como primeira prova de todas as mecanicas basicas quando Incarnam estiver mais barato e limpo.

## Tudo que voce deve saber sobre combate inicial e a primeira luta do tutorial
- `Fechado`: o fluxo correto do tutorial avancou por:
  - movimento inicial
  - dialogo com `Npc 2897`
  - equipar `10785 = Intrepid Ring`
  - primeira troca de mapa
  - primeiro agro no `Globe Celeste`
- `Fechado`: `ChangeMapMessage.Id = 9495`.
- `Fechado`: `GameRolePlayAttackMonsterRequestMessage.Id = 3188`.
- `Fechado`: `Id` correto no source nao bastava; o tipo tambem precisava estar liberado no `runtime/protocol-id-manifest.txt`.
- `Fechado`: a primeira sala de combate do tutorial precisava ser fiel:
  - `mapId = 152306688`
  - um unico `Globe Celeste`
  - sem duplicacao absurda
- `Fechado`: a luta deixou de ser "nao entra em combate" e passou a comecar de verdade.
- `Fechado`: houve um `NullReferenceException` real em `SequenceManager.cs` relacionado a `Fight.FighterPlaying` nulo; isso foi um bug verdadeiro, mas nao o unico gargalo da fase.
- `Util, mas revalidar`: depois, a luta avancou ate placement e ate primeiro turno com workaround estreito, e a familia `GameFightUpdateTeamMessage` virou suspeita real do disconnect restante.
- `Util, mas revalidar`: o combate nao deve ser dado como resolvido so porque o agro iniciou. Ainda faltavam:
  - hover de monstro
  - spells consistentes
  - fluxo de turno completo
  - rewards
- `Util, mas revalidar`: as spells passaram a aparecer, e o bug remanescente ficou cosmetico no rotulo `Alternative Word (13171)`. Isso e bem diferente de "spells nunca carregam".

### Provas mais fortes
- `thread_6.md`: fluxo ate a primeira luta, `SequenceManager`, ids de `ChangeMapMessage` e aggro

### Arquivos/artefatos para abrir se precisar aprofundar
- `N:\Codex_Programs\Dofus 2 private_2\thread_6.md`

### O que nao reabrir sem evidencia nova
- A ideia de que "combate esta pronto" so porque o primeiro clique de agro funciona.
- A ideia de que `SequenceManager` era o unico bug de combate dessa fase.

## Tudo que voce deve saber sobre missoes, journal, tracker e icones
- `Fechado`: o tracker antigo de progresso do projeto era inflado e enganoso. O modelo correto para o rebuild deve ser conservador:
  - escopos ponderados
  - travas duras
  - `currentSlice` separado do progresso global
- `Fechado`: no guided tutorial, `QuestId = 489` e especial e auto-iniciada.
- `Fechado`: no inicio da `489`, nao se deve exigir `!` no NPC para iniciar a quest.
- `Fechado`: o `TutorialUi` escuta `QuestStarted`, `QuestInfosUpdated` e `QuestStepValidated`; empurrar `QuestStepInfoMessage` cedo demais podia ser caminho errado.
- `Fechado`: o journal do tutorial nao deve ser tratado como quest comum. O client pode pedir detalhe por `QuestStepInfoRequestMessage` quando for a hora certa.
- `Fechado`: `MapNpcQuestInfo.npcsIdsWithQuest` precisa usar `contextualId`, nao `NpcId` de template, para o client conseguir ligar o icone ao ator vivo.
- `Fechado`: o bootstrap/listagem de quest ativa precisava usar `QuestActiveDetailedInformations`, nao uma forma rasa demais.
- `Util, mas revalidar`: a quest tutorial podia perder a linha de follow e precisar de reidratacao. O tracker lateral so aparece enquanto existir follow valido.
- `Util, mas revalidar`: os requests centrais do `QuestFrame` precisam estar alinhados no manifest/runtime:
  - `QuestListRequestMessage`
  - `QuestStartRequestMessage`
  - `QuestStepInfoRequestMessage`
  - `FollowQuestObjectiveRequestMessage`
  - `UnfollowQuestObjectiveRequestMessage`
  - `RefreshFollowedQuestsOrderRequestMessage`
- `Util, mas revalidar`: quando o foco saiu do tutorial e foi para Incarnam, o livro de missoes **ja aparecia**; o bug real do journal ficou reduzido a quests ativas detalhadas rasas demais.
- `Util, mas revalidar`: o baseline melhor para provar fluxo normal de missao passou a ser:
  - personagem novo em Incarnam pos-templo
  - `1632 Le village dans les nuages`
  - journal detalhado
  - tracker lateral
  - repere
  - icones `!` e `?`
  - rewards coerentes

### Provas mais fortes
- `thread_5.md` e `thread_6.md`: tutorial como sistema de progressao

### Arquivos/artefatos para abrir se precisar aprofundar
- `N:\Codex_Programs\Dofus 2 private_2\thread_5.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_6.md`

### O que nao reabrir sem evidencia nova
- A afirmacao "o livro de missoes nao aparece" como diagnostico padrao.
- A afirmacao "sidebar apareceu no print, entao a quest esta resolvida".
- A ideia de tratar `QuestId = 489` exatamente como quest normal de Incarnam.

## Ferramentas ja disponiveis no sistema
- Estado do ambiente no momento deste merge.
- `Fechado`: estas ferramentas ja estao disponiveis e nao devem ser reinstaladas sem necessidade:
  - `rg` / ripgrep `15.1.0`
  - `dotnet`
  - `java`
  - `mysql`
  - `git`
  - `winget`
  - `python`
  - `node`
  - `npm`
  - `ollama`
  - `FFDec` em `C:\Program Files (x86)\FFDec\ffdec.exe`
- `Fechado`: suportes locais ja presentes no repo original:
  - `runtime/distill/Invoke-DistilledCommand.ps1`
  - `runtime/distill/distill-profiles.json`
  - `support/dofus2toolbox`
  - `support/Cytrus-downloader`
- `Util, mas revalidar`: no projeto antigo, `mysql` local usava:
  - schema principal `giny_world`
  - usuario `root`
  - senha vazia

### Provas mais fortes
- probes de ambiente feitos no momento deste merge
- `thread_1.md`: FFDec como ferramenta valida para SWF
- `thread_6.md`: `distill` local e `Ollama` como infraestrutura ja existente

### Arquivos/artefatos para abrir se precisar aprofundar
- `C:\Program Files (x86)\FFDec\ffdec.exe`
- `N:\Codex_Programs\Dofus 2 private\runtime\distill\Invoke-DistilledCommand.ps1`
- `N:\Codex_Programs\Dofus 2 private\runtime\distill\distill-profiles.json`
- `N:\Codex_Programs\Dofus 2 private\support\dofus2toolbox`
- `N:\Codex_Programs\Dofus 2 private\support\Cytrus-downloader`

### O que nao reabrir sem evidencia nova
- Reinstalar `FFDec`, `ripgrep`, `MySQL`, `Ollama` ou wrappers locais so por reflexo.

## Armadilhas que mais custaram tempo
- `Fechado`: reabrir auth/launcher/serverId/protocol quando o bloqueio real ja mudou de lugar.
- `Fechado`: tratar `blank forest` como causa em vez de sintoma.
- `Fechado`: usar screenshot sozinho como prova de ausencia/presenca.
- `Fechado`: editar `.cs` e esquecer que o harness usa binario compilado.
- `Fechado`: reset e relaunch em paralelo.
- `Fechado`: repatch cego do mesmo `DofusInvoker.swf`.
- `Fechado`: esquecer que `Id` certo no source ainda pode falhar se o manifest nao liberar o tipo.
- `Fechado`: misturar mais de um bug primario no mesmo chat depois que o bloqueio mudou.
- `Util, mas revalidar`: helper de UI deve ser visto como ferramenta de transporte/diagnostico, nao como arbitro final de verdade de gameplay.

### Provas mais fortes
- `thread_2.md`: binario stale e falso negativo
- `thread_3.md` e `thread_4.md`: reset limpo, patch-state, runtime correto
- `thread_5.md` e `thread_6.md`: leitura visual errada, manifest, um bug por chat

### Arquivos/artefatos para abrir se precisar aprofundar
- `N:\Codex_Programs\Dofus 2 private_2\thread_2.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_4.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_5.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_6.md`

### O que nao reabrir sem evidencia nova
- Mudancas amplas guiadas por intuicao antes do primeiro delta real.
- Teorias amplas que nao expliquem o primeiro delta novo observado.

## O que o projeto novo deve aproveitar, o que deve revalidar, e o que nao deve importar
- `Fechado`: aproveitar imediatamente:
  - a hierarquia de evidencia `payload/log/DB > screenshot > recollection`
  - `ServerId = 36`
  - `7121 = ServerSelectionMessage`
  - a regra de patch minimo no client
  - patch-state deterministico
  - o fluxo conceitual fechado do pregame
  - `subarea 536 = Guided Tutorial`
  - `subarea 446 = Celestial Temple`
  - `Dofus Pour Les Noobs` como ancora humana principal, sempre cruzando ids locais
  - memoria curta, ledger e evidence index desde cedo
  - tracker honesto e conservador
- `Util, mas revalidar`: reprovar no rebuild:
  - conta vazia -> criacao -> mapa -> movimento
  - conta populada -> selecao -> mapa
  - criar pela selecao -> mapa
  - guided tutorial ate a primeira luta
  - journal/tracker/tutorial quest `489`
  - baseline de Incarnam com `1632`
  - hover/spells/rewards do combate
- `Util, mas revalidar`: usar Incarnam `1632` como baseline normal para missao basica antes de voltar a exigir tudo do tutorial.

### Provas mais fortes
- merge de `thread_1.md` a `thread_6.md`

### Arquivos/artefatos para abrir se precisar aprofundar
- `N:\Codex_Programs\Dofus 2 private_2\thread_1.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_4.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_5.md`
- `N:\Codex_Programs\Dofus 2 private_2\thread_6.md`

### O que nao reabrir sem evidencia nova
- Qualquer merge que perca a hierarquia de evidencia e volte a costurar o projeto por intuicao.
