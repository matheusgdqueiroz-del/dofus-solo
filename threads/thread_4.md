# Notas de Rebuild - Escopo Desta Thread

## Escopo deste arquivo
- Este arquivo registra apenas o que foi descoberto, validado ou alterado nesta thread.
- Ele foi escrito depois da leitura de `thread_1.md`, `thread_2.md` e `thread_3.md` para evitar conflito.
- Portanto, ele nao reexplica a fase de host signature, o primeiro `ServerId = 36`, o primeiro `7121`, nem a primeira prova de `conta vazia -> mapa`.
- O foco aqui comeca no ponto em que o projeto ja:
  - abria o jogo
  - chegava em criacao/customizacao
  - ja tinha prova automatizada de conta vazia indo ao mapa
- O problema desta thread foi:
  - corrigir a regressao/divergencia do fluxo real
  - fazer conta populada abrir na selecao por padrao
  - fazer selecao -> mapa
  - fazer criar pela selecao -> mapa
  - validar sem quebrar conta vazia
  - reduzir o custo de debug por ciclo

## Objetivo que esta thread perseguiu
- Fechar a fase de pregame de forma mais confiavel.
- Garantir a regra final de UX:
  - conta com personagens -> abrir na tela de selecao
  - conta vazia -> abrir na criacao
  - criar personagem pela selecao -> entrar no mapa
  - selecionar personagem existente -> entrar no mapa
- Manter o fluxo simples do usuario.
- Nao reabrir auth/launcher/protocol/serverId sem evidencia nova.

## Ponto de partida herdado no inicio desta thread
- Havia prova automatizada anterior de:
  - conta vazia
  - criacao
  - loading
  - mapa
  - movimento
- Mas o usuario reportou que, no fluxo simples real, ainda falhava:
  - abria `Abrir Dofus Solo.cmd`
  - clicava `Jogar Agora`
  - chegava em `CUSTOMISE`
  - clicava `Play`
  - o botao escurecia
  - nao aparecia loading
  - nao entrava no mapa
- A regra importante desta thread foi:
  - tratar isso como bug ainda aberto
  - nao declarar resolvido so porque um harness anterior havia passado

## Resultado real obtido nesta thread
- Esta thread fechou o pregame de forma muito mais completa do que a thread 3.
- Ficou validado com evidencia:
  - conta populada abre na selecao por padrao
  - selecionar personagem existente entra no mapa
  - criar personagem a partir da selecao entra no mapa
  - conta vazia continua abrindo na criacao e indo ao mapa
- O usuario confirmou no fim:
  - `Ok, realmente funcionou dessa vez`
- Portanto, para o rebuild, esta thread deve ser tratada como a consolidacao do pregame/selection flow.

## O que foi comprovado com evidencia

### 1. O primeiro bug real desta thread em conta populada estava no pos-criacao
- No repro reportado pelo usuario, o clique em `Play` na criacao nao gerava loading.
- A divergencia nova em log foi:
  - `Received CharacterCreationRequestMessage`
  - `Character created id=5 name='Cra'`
  - `SendCharactersList accountId=4 count=2`
  - depois o cliente desconectava
  - sem `CharacterSelectedSuccess`
  - sem `7066`
  - sem loading
- Interpretacao correta:
  - o request de criacao ja estava chegando
  - a criacao no servidor ja estava funcionando
  - o bug era o passo imediatamente depois
- Causa de codigo confirmada:
  - `CharacterHandler.cs` so auto-selecionava apos criacao quando `wasFirstCharacter`
  - isso falhava no caso "conta ja populada cria mais um personagem"

### 2. A correcao no `World` precisou generalizar a auto-selecao do personagem recem-criado
- Arquivo:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Handlers\Approach\CharacterHandler.cs`
- Ajuste importante desta thread:
  - apos `SendCharactersList()`, o `World` passou a auto-selecionar o personagem recem-criado tambem quando a conta ja tinha outros personagens
- Efeito desejado:
  - criacao explicita pela tela de selecao passa a continuar para loading -> mapa
- O log tambem foi ajustado para ficar neutro:
  - `Auto-selecting freshly created character ...`
  - e nao mais algo preso apenas a "first character"

### 3. O fluxo padrao da conta populada precisava ser selecao, nao criacao
- A regra final consolidada nesta thread foi:
  - `chars.length > 0` -> abrir selecao
  - `chars.length == 0` -> abrir criacao
  - criacao em conta populada so quando o usuario clicar de fato em criar personagem
- O arquivo principal desta parte foi:
  - `N:\Codex_Programs\Dofus 2 private\scripts\Patch-ZaapConnectionPopup.ps1`
- Regra funcional final consolidada ali:
  - `onCharactersListUpdated(...)`
    - lista > 0 -> `onCharacterSelectionStart(...)`
    - lista == 0 -> `onCharacterCreationStart([[\"create\"],true])`
  - `restorePregameUiIfNeeded()` passou a respeitar a mesma regra

### 4. O problema da selecao nao era "misterio de floresta vazia"; havia armadilhas concretas no client patch
- Esta thread encontrou e registrou algumas armadilhas objetivas no caminho da selecao:
  - `CharacterSelection` dependia do `Vector.<BasicCharacterWrapper>` original
  - transformar isso em `Array` quebrava a tela
  - a UI de `CharacterSelection` usava `getCurrentServer().gameTypeId` e podia quebrar cedo demais se o servidor atual ainda nao estivesse pronto
  - `waitingForCreation` nao podia continuar significando "auto-login normal"; precisava voltar a significar apenas intencao explicita de criar
- Resultado pratico:
  - a solucao final precisou respeitar o tipo original da lista
  - e esperar o estado minimo correto do client antes de abrir selecao

### 5. O caminho `Jogar Agora` e o `LaunchHarness start-game` realmente usam o mesmo core path
- Isso foi relido e reusado nesta thread para economizar tempo e reduzir variaveis:
  - botao `Jogar Agora` -> `SoloLauncherService.StartGameAsync(Settings)`
  - `runtime/LaunchHarness/Program.cs` -> `SoloLauncherService.StartGameAsync(settings)`
- Consequencia pratica importante:
  - nao tratar harness e botao como dois launchers diferentes
  - a diferenca relevante geralmente era:
    - estado runtime
    - patch-state
    - build stale
    - timing de UI

### 6. A selecao padrao da conta populada foi provada por screenshot
- Screenshot-chave:
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-123519-993-capture.png`
- Essa imagem passou a ser prova util de:
  - conta populada
  - primeira tela interativa correta = selecao
- Esta foi uma das validacoes mais importantes desta thread porque fechou a divergencia de UX principal.

### 7. Selecao de personagem existente -> mapa foi provada por screenshot e log
- Screenshots-chave:
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-123551-666-capture.png`
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-123650-362-capture.png`
- Trechos de `world.log` do mesmo ciclo:
  - `Received CharacterSelectionMessage`
  - `CharacterSelectionRequest id=4 found=True`
  - `ProcessSelection sending CharacterSelectedSuccess id=4 name='Soloselok'`
  - `Treating unknown message 7066 as post-selection context bootstrap for characterId=4`
  - `Send GameContextCreateMessage`
  - `Send CurrentMapMessage`
  - `Send MapComplementaryInformationsDataMessage`
- Conclusao:
  - conta populada -> selecao -> loading -> mapa ficou funcional

### 8. Criacao explicita a partir da selecao -> mapa foi provada por screenshot e log
- Screenshots-chave:
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-131131-204-capture.png`
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-131139-993-after-prepare-character.png`
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-131147-311-after-click-play.png`
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-131159-827-capture.png`
- Trechos de `world.log` do mesmo ciclo:
  - `Received CharacterCreationRequestMessage`
  - `Character created id=5 name='Solofxohp'`
  - `SendCharactersList accountId=4 count=2`
  - `Auto-selecting freshly created character ...`
  - `ProcessSelection sending CharacterSelectedSuccess ...`
  - `Treating unknown message 7066 as post-selection context bootstrap ...`
  - `Send MapComplementaryInformationsDataMessage`
- Conclusao:
  - criar via selecao passou a entrar no mapa sem regredir a UX de conta populada

### 9. A regressao de conta vazia foi revalidada depois do fix
- Para garantir que a correcao da conta populada nao quebrasse o fluxo antigo, esta thread limpou apenas a conta `jogo`.
- SQL usado para revalidar conta vazia:
```sql
DELETE FROM giny_auth.worldcharacters WHERE AccountId=4;
DELETE FROM giny_world.characters WHERE AccountId=4;
```
- Houve confirmacao intermediaria de limpeza `2 -> 0`.
- Screenshots-chave do ciclo vazio:
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-131904-149-capture.png`
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-131912-657-after-prepare-character.png`
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-131916-826-after-click-play.png`
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-131929-341-capture.png`
- Trechos de `world.log` do mesmo ciclo:
  - `OnAccountReceived accountId=4 charactersLoaded=0`
  - `SendCharactersList accountId=4 count=0`
  - `Received CharacterCreationRequestMessage`
  - `Character created id=4 name='Solonjhou'`
  - `Auto-selecting freshly created character ...`
  - `ProcessSelection sending CharacterSelectedSuccess ...`
  - `Treating unknown message 7066 ...`
  - `Send MapComplementaryInformationsDataMessage`
- Conclusao:
  - conta vazia continuou funcionando

### 10. O gargalo grande nao era o Zaap "em si"; era a opacidade do processo e o custo do repatch do SWF
- Esta thread mediu tempos e registrou a diferenca real entre os ciclos:
  - full clean patch rebuild: ~189s a ~203s
  - patch reuse: ~35s a ~38s
  - janela do cliente visivel apos o processo: ~3s a ~4s
- Interpretacao correta:
  - o custo forte vinha de rebuild/repatch, nao da janela do Zaap em si
  - era preciso parar de tratar todo reteste como "limpar tudo e reconstruir tudo"

### 11. O processo foi melhorado com timings no caminho oficial
- Arquivos alterados para isso:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\ClientPatchService.cs`
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\SoloLauncherService.cs`
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\ClientLaunchService.cs`
  - `N:\Codex_Programs\Dofus 2 private\Abrir Dofus Solo.cmd`
- Efeito util:
  - `runtime/client-launch.log` passou a mostrar melhor:
    - `PATCH|reused` vs rebuild
    - tempo de `ensure-client`
    - tempo por etapa de patch
    - tempo de `StartEverythingAsync`
    - tempo de `EnsureVisibleClientAsync`
- Isso foi uma das melhorias mais importantes para reduzir ciclos de 3 horas em bugs estreitos.

### 12. O helper de UI foi endurecido de novo nesta thread
- Arquivo:
  - `N:\Codex_Programs\Dofus 2 private\runtime\Drive-DofusUi.ps1`
- Ajustes/principios importantes desta thread:
  - a coordenada real da linha `Create a new character` precisou ser corrigida de `0.19,0.49` para `0.24,0.45`
  - `PrintWindow(...)` no AIR podia devolver um frame branco falso
  - o helper passou a tratar esse caso e cair para `CopyFromScreen`
  - houve reforco de foco/visibilidade de janela com `SetWindowPos` topmost toggle
- Valor pratico:
  - evita falso diagnostico de "blank forest" ou "nao abriu nada" quando a captura e que estava errada

## Mudancas relevantes feitas nesta thread no projeto original
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Handlers\Approach\CharacterHandler.cs`
- `N:\Codex_Programs\Dofus 2 private\scripts\Patch-ZaapConnectionPopup.ps1`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\ClientPatchService.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\SoloLauncherService.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\ClientLaunchService.cs`
- `N:\Codex_Programs\Dofus 2 private\runtime\Drive-DofusUi.ps1`
- `N:\Codex_Programs\Dofus 2 private\Abrir Dofus Solo.cmd`
- `N:\Codex_Programs\Dofus 2 private\runtime\auth-debug-notes-2026-04-05.md`

## O que deu certo e vale repetir no rebuild

### 1. Tratar o pregame como classe de bugs separada
- O sintoma visual `blank forest` nao e uma causa raiz unica.
- O jeito eficiente foi classificar o primeiro delta real:
  - `SendCharactersList` e nada de selecao util
  - selecao visivel mas nao jogavel
  - loading sem mapa
- Isso evita reabrir auth/launcher sem necessidade.

### 2. Corrigir a primeira divergencia real, nao a explicacao mais criativa
- O caso que destravou esta thread foi:
  - criacao em conta populada parava apos `SendCharactersList count=2`
  - isso apontou para a regra estreita em `CharacterHandler.cs`
- O ganho veio de corrigir exatamente esse `if`, nao de reexplicar o projeto todo.

### 3. Separar "default screen correta" de "criacao explicita"
- Misturar esses dois caminhos gerava regressao.
- O comportamento que ficou bom foi:
  - conta populada -> selecao
  - conta vazia -> criacao
  - clique explicito em criar -> criacao mesmo com conta populada

### 4. Reusar o patch-state em vez de repatch cego
- O caminho confiavel desta thread foi:
  - base limpa canonica
  - validar cadeia de patch
  - reutilizar quando possivel
- Repatch acumulativo so aumentava tempo e risco.

### 5. Melhorar o processo junto com o bug
- Os timings no launcher e o endurecimento do helper nao resolveram o bug sozinhos, mas reduziram muito o custo dos retestes seguintes.
- Esse tipo de melhoria vale quando:
  - nao muda o fluxo do usuario
  - reduz ambiguidade
  - reduz tempo de cada ciclo

## Armadilhas para evitar no rebuild

### 1. `LaunchHarness` usa binario ja compilado
- `LaunchHarness` carrega:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\bin\Debug\net6.0-windows\Giny.Zaap.dll`
- Consequencia:
  - editar `.cs` e testar com `LaunchHarness` sem buildar o projeto correspondente gera falso negativo

### 2. Reset e relaunch nunca devem rodar em paralelo
- Esta thread confirmou que isso pode matar o processo recem-subido e parecer bug do jogo.

### 3. `PrintWindow(...)` pode mentir no AIR
- Frame branco nao prova `blank forest`.
- A captura precisa ter fallback visual confiavel.

### 4. Nao confiar no nome digitado pelo helper como prova absoluta
- O patch de fallback de nome do client ainda pode trocar o nome final.
- A prova forte do nome final continua sendo:
  - `world.log`
  - ou consulta de banco

### 5. Nao reexecutar patch solto em SWF ja patchado achando que e idempotente
- Houve historico de `VerifyError #1107` quando uma etapa de patch foi reaplicada de forma ruim num SWF ja alterado.
- O caminho seguro continua sendo:
  - base limpa
  - rebuild controlado

### 6. `GameServerApproachFrame` foi uma hipotese util, mas nao foi o fix final estavel
- Esta thread investigou esse ponto porque o auto-connect generico era um suspeito forte.
- Porem o caminho seguro/final ficou concentrado no patch ja consolidado de pregame/login, nao em uma grande reimportacao arriscada nessa area.

### 7. Nao esquecer que prova automatizada e fluxo manual ainda podem divergir
- Um dos aprendizados centrais desta thread foi:
  - so porque o harness ja passou uma vez, isso nao fecha a regressao do usuario
- Sempre que o usuario relatar divergencia real:
  - reproduzir
  - capturar screenshot/log fresco
  - comparar com o ultimo caminho bom

## Regras de eficiencia que esta thread consolidou
- Se a mudanca for so C# em `World` ou `Zaap`, buildar o projeto relevante primeiro.
- Se a mudanca for so server-side, nao repatchar o SWF.
- So aceitar o custo de repatch completo quando o script SWF mudar de fato.
- Usar o primeiro delta novo apos cada acao importante, nao o tail mais barulhento.
- Tratar o `runtime/client-launch.log` como ferramenta de triagem e nao apenas como log passivo.
- Melhorar wrappers pequenos vale a pena:
  - `Abrir Dofus Solo.cmd` ganhou timestamps e `dotnet build --no-restore`
- Nao trocar o fluxo do usuario por outro so para debug se os dois wrappers chamarem o mesmo `StartGameAsync`.

## Artefato final util desta thread
- `N:\Codex_Programs\Dofus 2 private\runtime\client-patch-state.json`
- Estado final validado do patch na epoca desta thread:
  - `PatchChainVersion = 9338D20CB8AEF5B9C93B53BD163C08E7E9E55E4748AB0996810AE36BA00F1F19`
  - `BuildRoot = N:\Codex_Programs\Dofus 2 private\runtime\client-patch-build\20260406-153050-071`
- Observacao util:
  - se um probe temporario for adicionado e removido no SWF, a validacao de markers no `ClientPatchService` precisa acompanhar isso, senao o reuse fica incoerente

## Estado final exato desta thread
- O pregame ficou validado nas 3 rotas:
  - conta populada -> selecao -> mapa
  - conta populada -> criar novo personagem -> mapa
  - conta vazia -> criacao -> mapa
- `admin` foi preservado.
- O fluxo simples do usuario foi mantido.
- Honestidade importante para o rebuild:
  - a ultima rodada tecnica de validacao feita pela thread usou `LaunchHarness start-game`
  - isso continuava aceitavel porque ele chama o mesmo `SoloLauncherService.StartGameAsync(settings)` do botao `Jogar Agora`
  - mesmo assim, essa thread so deve ser considerada realmente fechada porque o usuario depois confirmou manualmente:
    - `Ok, realmente funcionou dessa vez`

## Handoff prudente para o rebuild
- No fim desta thread, o proximo bug a atacar passou a ser outro:
  - NPCs e mobs nao aparecendo
- Esta thread NAO resolveu isso.
- O unico cuidado de contexto que vale carregar daqui e:
  - o usuario afirmou que, pelo comportamento esperado do jogo oficial, o mapa/cenario inicial deveria ter NPC e mob
  - isso nao prova sozinho se a falha esta em DB local, spawn server-side ou renderizacao client-side
- Portanto, a proxima thread deve tratar esse proximo bug como novo escopo primario e nao misturar com o pregame que foi estabilizado aqui.

## Resumo curto para merge futuro
- Esta thread consolidou a fase de pregame.
- O fluxo final ficou:
  - conta populada abre na selecao
  - selecao existente entra no mapa
  - criacao pela selecao entra no mapa
  - conta vazia continua indo para criacao e depois mapa
- Os fixes mais importantes foram:
  - auto-selecao do personagem recem-criado tambem em conta populada
  - regra de tela padrao baseada na lista real de personagens
  - correcao do patch de selecao para respeitar `Vector` e estado minimo do servidor atual
  - timings no launcher/patch
  - endurecimento do helper de UI e da captura
- As maiores economias de tempo vieram de:
  - parar de repatchar SWF sem necessidade
  - buildar o projeto certo antes do harness
  - usar logs/screenshot frescos do primeiro delta
  - tratar `blank forest` como sintoma, nao como causa
