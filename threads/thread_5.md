# Notas de Rebuild - Escopo Desta Thread

## Escopo deste arquivo
- Este arquivo registra apenas o que foi descoberto, validado ou alterado nesta thread.
- Ele foi escrito depois da leitura de `thread_1.md`, `thread_2.md`, `thread_3.md` e `thread_4.md` para evitar conflito.
- Portanto, ele nao reexplica:
  - host signature / patch inicial do SWF
  - `ServerId = 36`
  - `7121 = ServerSelectionMessage`
  - a consolidacao do pregame ate `conta populada -> selecao -> mapa`
- O foco aqui comeca depois da fase em que o jogo ja:
  - abria
  - criava personagem
  - entrava no mapa
- O problema desta thread foi reconstruir a parte de mundo/progressao, com enfase no tutorial guiado e no inicio real do jogo.

## Objetivo que esta thread perseguiu
- Sair do modo "so entrar no mapa" e comecar a reconstruir a experiencia de Dofus real.
- Tratar quests, achievements, NPCs, mobs, spawns, drops e progressao como um sistema, e nao como features isoladas.
- Fazer isso com evidencia, sem reinventar auth/launcher/protocol.
- Criar uma base que ajudasse o projeto a ser self learning e economico em tokens.

## Resultado real obtido nesta thread
- Esta thread nao "terminou o jogo", mas fechou descobertas estruturais muito importantes para o rebuild.
- O projeto passou a ter:
  - import canonico util de quests/achievements/NPC messages a partir do client 2.63.9.16
  - pipeline de overlay curado para tutorial/spawn/dialog
  - probes read-only para provar verdade de mapa e readiness do tutorial
  - modelo de memoria curta para evitar reanalise cara
- A maior descoberta estrutural desta thread foi:
  - `subarea 536 = Guided Tutorial`
  - `subarea 446 = Celestial Temple`
- Isso muda a modelagem correta do inicio do jogo:
  - `536` e o prologo guiado real
  - `446` e a fase seguinte, ainda pre-Incarnam, com quests/combate/profissoes
- Outra conclusao importante:
  - `mapId=154010883` nao deve ser forcado como mapa de combate
  - ele foi provado como `BlueCells=0` e `RedCells=0`

## Contexto herdado de `thread_4.md`
- `thread_4.md` deixou o projeto com o pregame muito mais fechado:
  - conta populada -> selecao -> mapa
  - criar pela selecao -> mapa
  - conta vazia -> criacao -> mapa
- Esta thread comecou a partir desse ponto.
- O passo seguinte deixou de ser auth/launcher e passou a ser:
  - mundo
  - tutorial
  - quests
  - achievements
  - spawns
  - payload real de mapa

## O que foi comprovado com evidencia

### 1. O inicio do jogo precisava ser modelado em duas fases, nao como um bloco unico
- Evidencia de banco e probes desta thread:
  - `subareas.Id=536 Name='Guided Tutorial'`
  - `subareas.Id=446 Name='Celestial Temple'`
- Interpretacao assertiva:
  - o projeto nao deve mais tratar "tutorial" e "Celestial Temple" como a mesma coisa
  - isso evita costurar quest, NPC e mapa na fase errada

### 2. O client 2.63.9.16 ja traz muito do catalogo canonico, e isso deve ser a base do rebuild
- Esta thread consolidou a estrategia:
  - client local como verdade principal para ids, textos, topologia e catalogos
  - fontes externas apenas como overlay auditado
- Catalogos canonicos importados/validados nesta thread:
  - `5705` NPCs
  - `46266` NPC messages
  - `1934` quests
  - `2192` quest steps
  - `15159` quest objectives
  - `2893` achievements
  - `9539` achievement objectives
  - `6796` achievement rewards
- Consequencia pratica:
  - nao comecar reconstruindo "na mao" dados que o client ja oferece

### 3. O Dofus Pour Les Noobs deve ser usado como ancora humana principal para quests, mas so depois de cruzar ids locais
- Esta thread consolidou essa politica externa:
  - client local primeiro
  - Dofus Pour Les Noobs como ancora humana principal
  - DofusDB apenas sidecar/manual
  - dofusdude so se um endpoint de Dofus 2 for provado relevante
- Uso correto:
  - confirmar quest/mapa/NPC/ids no client local
  - so depois usar Dofus Pour Les Noobs para fluxo, coordenadas e coerencia

### 4. O projeto precisava de um modelo de memoria curta para nao virar um pesadelo de tokens
- Esta thread criou a disciplina:
  - `runtime/project-active-state.md`
  - `runtime/decision-ledger.md`
  - `runtime/evidence-index.jsonl`
- Regra consolidada:
  - ler primeiro o estado curto
  - ler so as entradas relevantes do ledger
  - abrir logs/screenshots por referencia
  - deixar `auth-debug-notes-2026-04-05.md` como arquivo historico
- Isso e importante para o rebuild novo:
  - seedar esse modelo cedo
  - evitar reabrir logs gigantes toda hora

### 5. O target antigo de mobs/NPCs em `154010883` estava errado
- Esta thread provou, com probe e log:
  - `mapId=154010883`
  - `curatedSpawnRules=4`
  - `npcSpawnCount=0`
  - `BlueCells=0`
  - `RedCells=0`
  - `CanSpawnMonsters=false`
- Conclusao assertiva:
  - o bug ali nao era "cliente nao renderiza"
  - e tambem nao era "import perdeu fight cells"
  - aquele mapa nao deve ser o alvo para forcamento de mobs

### 6. Os mapas do tutorial/Celestial Temple podiam ter `Blue/Red = 0/0` e mesmo assim serem combativeis
- Esta thread adicionou probes de verdade de mapa e mostrou isso em mapas do tutorial:
  - `153092354`
  - `153092356`
  - `153093380`
- Achado importante:
  - `Blue/Red = 0/0` nao basta para declarar "mapa sem combate"
  - varios mapas tinham dezenas de fight cells validas e placements derivados
- Consequencia pratica:
  - a camada correta era um resolvedor de placements
  - nao um "spawn anyway" cego

### 7. O client local tem modulo de tutorial; o bloqueio nao era ausencia de codigo cliente
- Esta thread decompilou e confirmou a existencia de:
  - `TutorialUi`
  - `TutorialStepManager`
  - `AdvancedTutorialStepManager`
- Conclusao:
  - o problema do tutorial nao era "client nao tem tutorial"
  - o problema era o fluxo e o conteudo server-side/source-backed

### 8. O guided tutorial ganhou pipeline/runtime proprio nesta thread
- Esta thread introduziu ou consolidou tabelas/runtime para:
  - `character_guided_tutorial`
  - `tutorial_scripted_objectives`
  - `npc_spawn_points`
  - `npc_dialog_nodes`
  - `npc_dialog_replies`
  - `npc_quest_flags`
  - `curated_fight_cells`
  - `curated_monster_groups`
  - `scripted_pvm_fights`
- Tambem consolidou:
  - quest objective `type 0` como adapter/tutorial scripted
  - quest objective `type 17` ligado ao fluxo real de craft
  - rewards por ratio de XP/Kamas

### 9. O guided tutorial e o Celestial Temple precisavam de gates explicitos por fase
- O objetivo desta thread deixou de ser "ligar tudo e rezar".
- A modelagem correta passou a ser readiness por fase:
  - `GuidedModeReady`
  - `TempleIntroReady`
  - `TempleCombatReady`
  - `TempleProfessionsReady`
  - `TempleGodsReady`
  - `PreIncarnamReady`
- Isso e importante para o rebuild:
  - nao mandar personagem novo para uma fase ainda nao provada
  - separar "runtime existe" de "fluxo do jogador pode depender disso"

### 10. Houve um bug real de colisao visual no mapa inicial do guided tutorial, e ele foi estreitado
- O overlay curado inicialmente podia jogar NPC/grupo perto demais da entrada do player.
- Esta thread corrigiu isso:
  - a escolha de fallback de celula passou a evitar a celula de entrada do tutorial
  - depois passou a evitar tambem a vizinhanca imediata da entrada
- Resultado observado nesta thread:
  - o player ficou visivelmente separado do NPC
  - isso removeu "player escondido pelo NPC" como causa principal

### 11. O mapa inicial do guided tutorial era `152305664` e o payload precisava ser tratado como verdade acima da leitura visual
- Esta thread concentrou o mapa inicial em:
  - `152305664`
- O guided tutorial tambem passou a persistir estado como:
  - `State`
  - `Phase`
  - `LastTutorialMapId`
  - `LastGuidedModeMapId`
  - `ReturnMapId`
- Consequencia:
  - resume/handoff nao devia mais depender de adivinhacao de mapa

### 12. O usuario corrigiu a leitura do screenshot, e isso mudou o bloqueio
- No fim desta thread houve uma correcao explicita do usuario:
  - no screenshot `ui-20260407-100027-904-capture.png`
  - o NPC estava visivel
  - descrito como "um passaro homem com um livro"
- Regra assertiva que deve entrar no rebuild:
  - nao usar screenshot sozinho para provar ausencia de ator
  - e, quando o usuario corrigir a leitura do screenshot, essa correcao vale mais do que a interpretacao visual do modelo ate surgir prova mais forte
- Consequencia:
  - a hipotese "NPC inicial ainda nao aparece" ficou invalida
  - o proximo passo correto passou a ser payload/quest flow, nao mais spawn visual

## Dados/artefatos concretos desta thread

### Conta e personagem de teste mais importantes
- Conta:
  - `solo2 / solo2`
- Estado util desta thread:
  - `accountId=3`
  - `characterId=6`
  - `Name=Soloradwm`

### Rows curadas importantes observadas apos sync
- `npc_spawn_points`:
  - `9300001 2897 map 152305664 cell 328`
  - `9300002 2897 map 152306690 cell 42`
  - `9300003 2897 map 152307714 cell 42`
- `curated_monster_groups`:
  - `9400001 map 152306688 cell 42 monster 2785`
  - `9400002 map 152307712 cell 42 monster 2781`
- Observacao:
  - ao longo desta thread, parte dessas celulas foi ajustada de novo para evitar a vizinhanca da entrada
  - portanto, no rebuild, essas rows devem ser tratadas como evidencia de direcao, nao como verdade eterna sem revalidacao

### Screenshots mais importantes desta thread
- `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260407-094159-273-capture.png`
- `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260407-094249-165-capture.png`
- `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260407-095934-465-capture.png`
- `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260407-100027-904-capture.png`

### Logs/probes mais importantes desta thread
- `N:\Codex_Programs\Dofus 2 private\runtime\world.log`
- `N:\Codex_Programs\Dofus 2 private\runtime\map-truth-probe-20260406-225632.jsonl`
- `N:\Codex_Programs\Dofus 2 private\runtime\map-truth-probe-20260406-225702.jsonl`
- `N:\Codex_Programs\Dofus 2 private\runtime\map-truth-probe-20260407-tutorial-fight-candidates.jsonl`
- `N:\Codex_Programs\Dofus 2 private\runtime\guided-tutorial-probe-20260407-latest.jsonl`
- `N:\Codex_Programs\Dofus 2 private\runtime\tutorial-map-family-investigation-20260407.md`

## Arquivos mais importantes tocados por esta thread
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.DbSync\Program.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.DbSync\D2OSynchronizer.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.DbSync\OverlaySynchronizer.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.DbSync\MapTruthProbe.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.DbSync\GuidedTutorialProbe.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Progression\GuidedTutorialManager.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Progression\GuidedTutorialDiagnostics.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Maps\Instances\MapInstance.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Maps\Instances\ClassicMapInstance.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Maps\Npcs\NpcsManager.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Entities\Npcs\Npc.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Handlers\Roleplay\Maps\MapsHandler.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Fights\FightManager.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Fights\FightPvM.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Entities\Monsters\MonsterGroup.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Entities\Monsters\MonstersManager.cs`

## O que deu certo e vale repetir no rebuild

### 1. Tratar o jogo como sistema
- Esta thread so avancou quando parou de pensar "fazer NPC aparecer" ou "fazer achievement existir".
- O caminho certo foi:
  - world data
  - progression
  - rewards
  - craft
  - dialogs
  - gates por fase
  - mapa real

### 2. Fazer preflight de dominio antes de mexer
- Antes de entrar em uma area nova, esta thread consolidou a necessidade de checar:
  - comportamento esperado do jogador
  - mensagens/estado relevantes
  - dependencias de dados
  - efeitos colaterais em progressao/reward
  - ancora externa confiavel

### 3. Provar primeiro a verdade de mapa antes de inventar spawn
- `probe-map-truth` foi uma das melhores decisoes desta thread.
- Ele evitou:
  - culpar o client sem prova
  - culpar o banco errado
  - forcar mob em mapa que nao devia ser o alvo

### 4. Usar o client como verdade principal e overlays como complemento
- Essa thread mostrou que reconstruir tudo "de fora para dentro" seria mais fraco.
- O caminho bom e:
  - client canonico
  - overlay curado auditado
  - fonte humana so depois

### 5. Criar memoria curta cedo
- O ganho de tokens desta thread veio de parar de reler tudo sempre.
- Para o rebuild, vale copiar essa disciplina logo no inicio.

### 6. Fazer fixes estreitos e observabilidade estreita
- Exemplos que funcionaram nesta thread:
  - logging so para mapa alvo
  - probes read-only
  - gates por fase
  - corrigir colisao de celula de entrada em vez de redesenhar o sistema inteiro

## Armadilhas para evitar no rebuild

### 1. Nao reabrir auth/launcher/protocol/serverId so porque um mapa parece estranho
- Nesta thread, a maioria dos bugs reais ja era mundo/progressao/tutorial.
- Reabrir bootstrap antigo sem prova nova desperdicaria muito tempo.

### 2. Nao usar screenshot sozinho para provar ausencia de ator
- Isso foi provado na pratica nesta thread.
- O modelo leu o screenshot errado.
- O usuario corrigiu.
- O payload/log tem prioridade.

### 3. Nao tratar `Blue/Red = 0/0` como sinonimo automatico de "sem combate"
- Em mapas especiais do tutorial isso seria uma conclusao errada.

### 4. Nao costurar `536` e `446` como se fossem a mesma fase
- Essa foi provavelmente a descoberta estrutural mais importante desta thread.

### 5. Nao inventar NPC/mapa/quest fora de ids locais so porque a fonte externa parece plausivel
- Dofus Pour Les Noobs ajuda muito.
- Mas sem cruzar com ids locais vira risco de costura incoerente.

### 6. Nao deixar a memoria do projeto virar um dump gigante
- O rebuild novo deve evitar logs narrativos enormes.
- Guardar:
  - deltas reais
  - traps duraveis
  - invariantes provadas
  - proximo passo estreito

## Estado exato de handoff desta thread
- O ultimo delta importante desta thread foi uma correcao de leitura:
  - o NPC inicial do guided tutorial aparentemente ja estava visivel
  - portanto esse nao era mais o bloqueio principal
- O proximo passo correto ficou sendo:
  1. confirmar pelo payload/log do mapa inicial `152305664` quais atores entram em `MapComplementaryInformationsDataMessage`
  2. se player + NPC estiverem corretos, parar de gastar tempo com spawn visual do mapa inicial
  3. empurrar a quest `489` para frente e achar o proximo bloqueio real de gameplay
- Em outras palavras:
  - o handoff desta thread nao e "falta NPC"
  - o handoff desta thread e "spawn inicial aparentemente ok; seguir para payload/progressao"

## Resumo curto para merge futuro
- Esta thread fez a transicao do projeto de "pregame funcionando" para "reconstrucao do jogo de verdade".
- As descobertas mais importantes foram:
  - `subarea 536 = Guided Tutorial`
  - `subarea 446 = Celestial Temple`
  - `154010883` nao deve ser forcado como mapa de combate
  - o client 2.63 ja oferece grande parte do catalogo canonico
  - Dofus Pour Les Noobs deve ser a principal ancora humana externa para quests
  - o projeto precisa de memoria curta e ledger para ser self learning e economico em tokens
  - o guided tutorial ganhou pipeline/runtime proprio
  - a hipotese "NPC inicial nao aparece" ficou invalidada pela correcao do usuario
- Para o rebuild, esta thread deve ser lida como:
  - a thread que organizou a reconstrucao do tutorial/progressao
  - e que separou corretamente guided mode, Celestial Temple e Incarnam
