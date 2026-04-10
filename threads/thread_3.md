# Notas de Rebuild - Escopo Desta Thread

## Escopo deste arquivo
- Este arquivo registra apenas o que foi descoberto, validado ou alterado nesta thread.
- Ele foi escrito depois da leitura de `thread_1.md` e `thread_2.md` para evitar conflito.
- Portanto, ele **nao** reexplica a fase inicial de host signature, `ServerId = 36`, `7121`, ou o primeiro alcance da tela de criacao.
- O foco aqui comeca **depois** do ponto em que a thread 2 terminou:
  - fluxo ja chegava em `CUSTOMISE`
  - criacao ja chegava ao `World`
  - o bug principal estava no trecho `conta vazia -> criar personagem -> sair da criacao -> entrar no mapa`

## Objetivo que esta thread perseguiu
- Parar de perder tempo reabrindo auth/launcher/protocol quando o problema real ja estava no pregame do cliente e no pos-criacao.
- Fazer o fluxo simples do usuario continuar sendo:
  - abrir `Abrir Dofus Solo.cmd`
  - clicar `Jogar Agora`
  - criar o proprio personagem
  - entrar no mapa
- Provar com evidencia real:
  - criacao do proprio personagem
  - transicao para loading
  - entrada no mapa
  - resposta a movimento

## Resultado real obtido nesta thread
- Esta thread conseguiu provar o fluxo:
  - conta vazia
  - criacao do proprio personagem
  - loading
  - entrada no mapa
  - movimento
- A prova foi feita com:
  - `world.log`
  - `client-launch.log`
  - screenshots do loading, do mapa e do personagem movido
- Ao mesmo tempo, esta thread **nao** deve ser lida como "resolvido para sempre":
  - depois do sucesso automatizado, o usuario ainda reportou inconsistencia no fluxo manual real
  - portanto o rebuild novo deve tratar estes achados como trilha comprovada e nao como garantia de confiabilidade final

## Ponto de partida herdado no inicio desta thread
- Quando esta thread comecou, o conhecimento util ja era:
  - o fluxo normal ja havia chegado na tela de criacao/customizacao
  - `CharacterCreationRequestMessage` ja era recebido no `World`
  - o principal suspeito ja nao era mais auth puro
  - havia forte historico de runtime stale/binario antigo atrapalhando conclusoes
- O primeiro cuidado desta thread foi operacional:
  - parar de debugar estado contaminado
  - confirmar processo vivo, portas, logs frescos e screenshots frescas

## O que foi comprovado com evidencia

### 1. `Jogar Agora` e `LaunchHarness start-game` usam o mesmo caminho de launch
- Isso foi importante para reduzir o numero de variaveis durante o debug.
- Evidencia lida em source:
  - `Abrir Dofus Solo.cmd` apenas compila e abre `Giny.Zaap.exe`
  - `Giny.Zaap/Components/MainLayout.razor` chama `SoloLauncherService.StartGameAsync(Settings)` no botao `Jogar Agora`
  - `runtime/LaunchHarness/Program.cs` tambem chama `SoloLauncherService.StartGameAsync(settings)`
- Consequencia pratica:
  - quando o harness funcionava e o fluxo do usuario nao, a investigacao tinha que olhar estado runtime, patch-state, timing e UI, e nao inventar dois launchers diferentes

### 2. O launcher parou de precisar repatch cego do SWF vivo a cada launch
- Nesta thread, o caminho confiavel passou a usar validacao deterministica do client patch.
- Artefato de estado:
  - `N:\Codex_Programs\Dofus 2 private\runtime\client-patch-state.json`
- Base limpa canonica usada no fluxo:
  - `N:\Dofus263\client-2.63.9.16-en\DofusInvoker.pre-source-rebuild.bak`
- Evidencia de runtime:
  - `client-launch.log` registrou launches com:
    - `ZAAP_RUNTIME_MARKER ...`
    - `Jogo aberto com janela visivel ... Handshake=True`
  - `launchharness-bg.out` registrou:
    - `SWF validado; reutilizando patch existente.`
- Conclusao util para o rebuild:
  - nao repatchar o `DofusInvoker.swf` ativo de forma acumulativa
  - validar a cadeia de patches
  - se estiver valida, reutilizar

### 3. O fluxo simples desta fase passou a usar uma conta limpa separada da conta de admin
- Nesta thread, os defaults observados/ativos do launcher eram:
  - `jogo/jogo`
- Isso aparece no source atual em:
  - `Giny.Zaap/SoloLauncherService.cs`
  - `Giny.Zaap/LauncherSettings.cs`
  - `Giny.Zaap/AppState.cs`
- Interpretacao util:
  - `admin` ficou para manutencao/debug
  - o fluxo do jogador ficou concentrado numa conta limpa
- Isso foi importante porque separou dois problemas diferentes:
  - conta populada, com caminho de selecao de personagem
  - conta vazia, com caminho de criacao inicial

### 4. O bug do `blank forest` em conta vazia foi superado com patch especifico no `Connection.as`
- O ponto mais importante do lado cliente nesta thread foi:
  - em conta vazia, o cliente recebia `CharactersListMessage count=0`
  - mas nem sempre criava a UI de pregame corretamente
- O patch chave ficou em:
  - `N:\Codex_Programs\Dofus 2 private\scripts\Patch-ZaapConnectionPopup.ps1`
- Mudancas importantes desse patch:
  - import de `PlayerManager`
  - `restorePregameUiIfNeeded()`
  - agenda por `setTimeout(...)`
  - leitura de `PlayerManager.getInstance().charactersList`
  - se `charactersList` estiver vazia, força o caminho de `characterCreation`
  - `onCharactersListUpdated(...)` passou a:
    - chamar `onCharacterSelectionStart(...)` se lista > 0
    - chamar `onCharacterCreationStart([["create"],true])` se lista == 0
- Evidencia visual desta fase:
  - o projeto saiu do fundo vazio/blank forest e voltou a mostrar a criacao/customizacao para conta vazia

### 5. O helper de UI foi calibrado contra a tela real
- Arquivo:
  - `N:\Codex_Programs\Dofus 2 private\runtime\Drive-DofusUi.ps1`
- Ajustes importantes confirmados nesta thread:
  - `Test-ClassSelectionScreen(...)` ficou menos restritivo
  - `Test-CustomizeScreen(...)` ficou menos restritivo
  - coordenada de `choose-class` foi corrigida
  - coordenada de `click-selection-play` foi corrigida
  - `prepare-character` e `click-play` passaram a gerar screenshots consistentes
- Valor pratico:
  - evitou debug falso de "clicou e nao aconteceu nada" quando na verdade o detector de tela ou a coordenada estavam errados

### 6. A criacao do personagem no servidor foi comprovada varias vezes neste fluxo
- Nesta thread, `world.log` mostrou repetidamente:
  - `Received CharacterCreationRequestMessage`
  - `CharacterCreationRequest validation=OK`
  - `Character created ...`
  - `Character list refreshed count=1`
  - `SendCharactersList accountId=... count=1`
- Isso foi essencial para separar:
  - bug de UI/click
  - bug de criacao
  - bug pos-criacao
- A partir daqui, o problema ficou reduzido ao que vinha **depois** da criacao

### 7. O `World` tinha um bug real no primeiro personagem e ele foi corrigido
- Arquivo:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Handlers\Approach\CharacterHandler.cs`
- Bug encontrado nesta thread:
  - `HandleCharacterFirstSelectionMessage(...)` estava hardcoded para:
    - mandar `CharacterSelectedErrorMessage`
    - reenviar `CharactersList`
    - `return`
- Correcao aplicada:
  - o handler passou a selecionar normalmente o personagem quando encontrado
  - tambem passou a logar:
    - `Received CharacterFirstSelectionMessage ...`
- Valor pratico:
  - isso removia um bloqueio real de primeiro personagem/primeira entrada

### 8. O pos-criacao em conta vazia precisou de um fallback server-side estreito
- Mesmo com a criacao funcionando, houve um momento em que:
  - o cliente criava o personagem
  - o `World` reenviava `CharactersListMessage count=1`
  - o cliente permanecia em `CUSTOMISE`
  - nao mandava selecao explicita util
- Correcao estreita aplicada no mesmo `CharacterHandler.cs`:
  - dentro de `CreateCharacter(...)`, detectar:
    - `wasFirstCharacter = client.Characters.Count == 0`
  - depois de `SendCharactersList()`, auto-selecionar **apenas** o primeiro personagem recem-criado dessa conta vazia
  - log:
    - `Auto-selecting freshly created first character ...`
- Esse fallback foi importante porque:
  - mantinha o fluxo simples do jogador
  - nao mexia no caminho de contas ja populadas
  - evitava reabrir o cliente inteiro de novo

### 9. O fallback de contexto do mapa por unknown `7066` foi reutilizado com sucesso para o personagem novo
- Arquivo:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Handlers\ContextHandler.cs`
- Estado observado nesta thread:
  - apos a auto-selecao do personagem recem-criado, o cliente ainda usava o mesmo padrao estranho:
    - mandava unknown `7066`
  - o fallback existente tratava isso como bootstrap de contexto
- Evidencia em `world.log`:
  - `Treating unknown message 7066 as post-selection context bootstrap for characterId=4`
  - `Send GameContextCreateMessage`
  - `Send CurrentMapMessage`
  - `Send CharacterStatsListMessage`
  - `Received MapInformationsRequestMessage`
  - `Send MapComplementaryInformationsDataMessage`
  - `Send MapFightCountMessage`
  - `Send BasicNoOperationMessage`
  - `Send BasicTimeMessage`
  - `Send GameMapNoMovementMessage`

### 10. A entrada no mapa do personagem novo foi comprovada por screenshot
- Screenshots-chave desta thread:
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-061618-394-capture.png`
    - loading screen real depois do `PLAY`
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-061646-962-capture.png`
    - personagem novo no mapa em Incarnam
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-061821-148-capture.png`
    - personagem em posicao diferente depois de clique de movimento
- Isso provou:
  - criacao do proprio personagem
  - loading
  - mapa
  - resposta a clique de movimento

## Mudancas relevantes feitas nesta thread no projeto original
Estas mudancas existem em `N:\Codex_Programs\Dofus 2 private` e servem de referencia para o rebuild, mas devem ser reaplicadas com cuidado e em ordem pequena.

### Launcher / patch-state
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\ClientPatchService.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\SoloLauncherService.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\AppState.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\LauncherSettings.cs`

### Client patch / pregame
- `N:\Codex_Programs\Dofus 2 private\scripts\Patch-ZaapConnectionPopup.ps1`
- `N:\Codex_Programs\Dofus 2 private\scripts\Patch-CharacterCreationDirectSend.ps1`
- `N:\Codex_Programs\Dofus 2 private\scripts\Patch-CharacterCreationNameFallback.ps1`

### World / character flow
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Handlers\Approach\CharacterHandler.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Handlers\ContextHandler.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Managers\Shortcuts\ShortcutBar.cs`

### Helper de UI
- `N:\Codex_Programs\Dofus 2 private\runtime\Drive-DofusUi.ps1`

## O que deu certo e vale repetir no rebuild

### 1. Tratar conta vazia como fluxo principal do jogador
- A conta limpa separada da `admin` ajudou muito a tirar o ruido da UI mista de selecao + criacao.

### 2. Confirmar cada etapa por screenshot + `world.log`
- Isso foi o que mais economizou tempo.
- O padrão util desta thread foi sempre:
  - screenshot fresca
  - `world.log` fresco
  - so depois editar

### 3. Isolar criacao e pos-criacao como bugs diferentes
- Primeiro provar que o request chega.
- Depois provar se o servidor cria.
- Depois provar se a selecao acontece.
- Depois provar se o contexto entra.
- Essa separacao foi decisiva.

### 4. Usar fallback estreito em vez de refatoracao grande
- O que funcionou aqui foram remendos pequenos e direcionados:
  - `ShortcutBar` guard
  - `HandleCharacterFirstSelectionMessage(...)`
  - auto-selecao do primeiro personagem recem-criado
  - fallback `7066`

### 5. Reset limpo antes de testes importantes
- Esta thread esbarrou varias vezes em binario/processo stale.
- O caminho certo sempre foi:
  - encerrar runtime
  - confirmar portas
  - rebuild
  - relaunch
  - olhar so o primeiro delta novo

## Armadilhas para evitar no rebuild

### 1. Nao repatchar o SWF vivo de forma acumulativa
- O caminho bom desta thread dependia de patch-state e base limpa canonica.
- Repatch cego do mesmo SWF vivo e um caminho forte para regressao.

### 2. Nao tratar ausencia de trace de modulo como prova
- `connection-ui-trace.log` e `login-ui-trace.log` continuaram pouco confiaveis.
- A evidencia que realmente fechou conclusoes foi `world.log` + screenshot.

### 3. Nao voltar para auth se o `World` ja mostra criacao
- Se o log ja tem:
  - `Received CharacterCreationRequestMessage`
  - `Character created`
- entao o problema ja mudou de lugar.

### 4. Nao tentar grandes imports no FFDec em areas sensiveis do client
- Nesta thread, tentativas de patchar areas maiores do client por FFDec esbarraram em erros do tipo:
  - `package internal access`
- Esses caminhos gastaram tempo e nao foram o que resolveu.

### 5. Nao assumir que a prova automatizada significa confiabilidade final do fluxo manual
- Esta thread provou o caminho ate o mapa com automacao.
- Mas depois o usuario ainda relatou inconsistencia no fluxo manual real.
- O rebuild deve considerar isso uma lacuna de confiabilidade ainda aberta.

### 6. Nao matar processos `.NET` arbitrariamente
- Nesta thread houve situacoes com varios `dotnet.exe`.
- O jeito certo foi identificar o tree pelo `CommandLine` e `ParentProcessId`, em vez de sair fechando tudo no escuro.

## Informacoes operacionais uteis desta thread

### Banco local observado nesta thread
- `MySQL` local em `127.0.0.1`
- usuario:
  - `root`
- senha:
  - vazia
- bancos usados aqui:
  - `giny_auth`
  - `giny_world`

### Queries uteis usadas nesta thread
Inspecao da conta do fluxo simples:
```sql
SELECT Id,Username,Password,Nickname,LastSelectedServerId
FROM giny_auth.accounts
WHERE Username='jogo';

SELECT Id,AccountId,Name,BreedId,MapId
FROM giny_world.characters
WHERE AccountId IN (SELECT Id FROM giny_auth.accounts WHERE Username='jogo');
```

Limpeza da conta `jogo` para revalidar conta vazia:
```sql
DELETE FROM giny_auth.worldcharacters WHERE AccountId=4;
DELETE FROM giny_world.characters WHERE AccountId=4;
```

## Estado final exato desta thread
- Esta thread conseguiu chegar ao mapa com personagem novo criado no proprio fluxo de criacao.
- O `World` mostrou:
  - criacao
  - auto-selecao do primeiro personagem
  - entrada no contexto do mapa via fallback `7066`
- A UI mostrou:
  - loading
  - mapa
  - movimento
- Porem, por prudencia para o rebuild:
  - considerar o fluxo "conceitualmente provado"
  - mas nao tratar como "produto final confiavel" sem novo reteste manual do usuario no fluxo simples

## Proximo passo recomendado se for reconstruir esta linha de trabalho
1. Recriar primeiro o launcher com patch-state deterministico e base limpa do SWF.
2. Recriar o fluxo do jogador em conta limpa separada da `admin`.
3. Reaplicar o patch de `Connection.as` que restaura a UI de pregame em conta vazia.
4. Reaplicar `direct send` e `name fallback` para criacao.
5. Reaplicar o guard de `ShortcutBar`.
6. Reaplicar a correcao de `HandleCharacterFirstSelectionMessage(...)`.
7. Reaplicar o fallback de auto-selecao do primeiro personagem recem-criado.
8. Reaplicar o fallback `7066` de entrada no contexto.
9. Validar exatamente nesta ordem:
   - conta vazia
   - `CUSTOMISE`
   - `CharacterCreationRequestMessage`
   - loading
   - mapa
   - movimento
10. So depois disso retestar com usuario no fluxo real `Abrir Dofus Solo.cmd -> Jogar Agora`.

## Artefatos uteis desta thread
- `N:\Codex_Programs\Dofus 2 private\runtime\auth-debug-notes-2026-04-05.md`
- `N:\Codex_Programs\Dofus 2 private\runtime\world.log`
- `N:\Codex_Programs\Dofus 2 private\runtime\auth.log`
- `N:\Codex_Programs\Dofus 2 private\runtime\client-launch.log`
- `N:\Codex_Programs\Dofus 2 private\runtime\client-patch-state.json`
- `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-061618-394-capture.png`
- `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-061646-962-capture.png`
- `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260406-061821-148-capture.png`

## Resumo curto para merge futuro
- Esta thread fechou a fase "conta vazia -> criacao do proprio personagem -> loading -> mapa".
- O que mais importou foi:
  - patch-state deterministico no launcher
  - patch de pregame para conta vazia
  - correcao do `CharacterFirstSelectionMessage`
  - auto-selecao estreita do primeiro personagem recem-criado
  - fallback `7066` para entrar no mapa
- A prova forte desta thread nao foi opiniao, e sim:
  - `world.log`
  - screenshots de loading/mapa/movimento
- Mesmo assim, o rebuild novo deve tratar esta thread como trilha comprovada, mas ainda exigir reteste manual real do fluxo simples antes de declarar vitoria final.
