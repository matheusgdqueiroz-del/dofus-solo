# Notas de Rebuild - Escopo Desta Thread

## Escopo deste arquivo
- Este arquivo registra apenas o que foi descoberto, validado ou alterado nesta thread.
- Nao mistura conclusoes de outras threads alem do que foi lido em `thread_1.md` para evitar conflito.
- O foco aqui foi o caminho depois do bloqueio inicial de autenticacao do host, ate chegar na tela de criacao de personagem e estreitar o bug seguinte.

## Objetivo que esta thread perseguiu
- Fazer o fluxo local/offline chegar alem do auth e do launcher.
- Manter o fluxo simples do usuario:
  - abrir `Abrir Dofus Solo.cmd`
  - clicar em `Jogar Agora`
- Chegar na tela de selecao/criacao de personagem.
- Avancar da criacao para a entrada real no jogo.

## Resultado real obtido nesta thread
- O fluxo avancou muito alem do ponto da thread 1.
- Foi possivel chegar na tela de criacao/customizacao de personagem no cliente.
- O usuario confirmou que o fluxo normal `Abrir Dofus Solo.cmd -> Jogar Agora` chegou nessa tela.
- O pedido de criacao de personagem passou a chegar no `World` local e o personagem foi criado com sucesso no servidor.
- O bloqueio final desta thread ficou estreitado para o passo imediatamente apos a criacao.

## O que foi comprovado com evidencia

### 1. O auth e o world ja estavam funcionando o suficiente para chegar na tela de personagem
- `auth.log` passou a mostrar:
  - `Received IdentificationMessage`
  - `IdentificationSuccessMessage`
  - `ServersListMessage`
  - `SelectedServerDataMessage`
- `world.log` passou a mostrar:
  - `Received AuthenticationTicketMessage`
  - `AuthenticationTicketAcceptedMessage`
  - `CharactersListMessage`

### 2. O `ServerId` local precisava existir de verdade no cliente
- O projeto/local estava usando `ServerId = 1`.
- O cliente 2.63.9.16 nao conhece `1` em `Servers.d2o`.
- O `ServerId` local foi alinhado para `36`.
- Isso foi parte importante para fazer a UI de personagem aparecer.

### 3. O fluxo normal do usuario realmente bate com o fluxo de teste
- O usuario confirmou que `Abrir Dofus Solo.cmd -> Jogar Agora` entrou na tela de criacao.
- Portanto, o problema deixou de ser um caminho de teste artificial e passou a estar no fluxo real do uso.

### 4. O cliente 2.63 usava `7121` como `ServerSelectionMessage`
- Nesta thread foi confirmado que `7121` nao era `CharacterSelectionMessage`.
- `7121` foi alinhado como `ServerSelectionMessage`.
- Isso evitou leituras falsas no socket do world.

### 5. A tela de criacao/customizacao foi documentada por screenshot
- Screenshot util da tela pronta para clicar em `Play`:
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260405-170045-575-capture.png`
- Screenshot logo apos o clique de teste em `Play`:
  - `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260405-170218-098-after-click-play.png`

### 6. O request de criacao de personagem passou a funcionar no servidor
- O `world.log` mostrou explicitamente:
  - `Received CharacterCreationRequestMessage`
  - `CharacterCreationRequest validation=OK`
  - `Character created id=1 name='Solougtyh'`
- Isso prova que o problema deixou de ser:
  - nome
  - clique no botao
  - serializacao do request
  - validacao de criacao

## Mudancas relevantes feitas nesta thread no projeto original
Estas mudancas foram feitas em `N:\Codex_Programs\Dofus 2 private` e servem como referencia para o rebuild novo.

### 1. Patch no cliente para escolher o servidor local ja no login
- Arquivo:
  - `N:\Codex_Programs\Dofus 2 private\scripts\Rebuild-OfflineAuthSwf.ps1`
- Foi patchado `AuthentificationFrame.processInvokeArgs()` para usar:
  - `LoginValidationWithTicketAction.create(username,value,true,36);`
- Efeito:
  - o cliente passou a auto-selecionar o servidor local `36`
  - reduziu bastante o atrito na tela de servidor

### 2. Alinhamento do protocolo para `ServerSelectionMessage`
- Arquivo:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Protocol\Messages\Connection\ServerSelectionMessage.cs`
- Ajuste:
  - `Id = 7121`

### 3. Handler no world para o `ServerSelectionMessage`
- Arquivo:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Handlers\Approach\CharacterHandler.cs`
- Foi adicionado um handler para `ServerSelectionMessage` no world socket.

### 4. Tentativa de corrigir o pos-criacao no world
- Arquivo:
  - `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Handlers\Approach\CharacterHandler.cs`
- Ultima intencao correta desta thread:
  - apos criar o personagem, nao chamar `ProcessSelection(client)` imediatamente
  - atualizar `client.Characters`
  - reenviar `CharactersListMessage`
- Motivo:
  - o cliente parecia aceitar `CharacterCreationResult(OK)`, mas nao o salto imediato para `CharacterSelectedSuccess`

### 5. Helper de UI para screenshot e clique
- Arquivo:
  - `N:\Codex_Programs\Dofus 2 private\runtime\Drive-DofusUi.ps1`
- Este helper foi usado para:
  - capturar screenshots
  - fechar popups
  - escolher classe
  - preencher nome
  - clicar em `Play`
- Correcao importante feita nesta thread:
  - `Test-CustomizeScreen()` estava restritivo demais
  - o limite do verde do botao foi reduzido de `0.20` para `0.15`
  - isso evitou falso negativo numa tela que claramente era `CUSTOMISE`

## O que deu certo e vale repetir no rebuild

### 1. Usar `ServerId = 36`
- Isso foi um passo importante para sair do fundo vazio e chegar na UI de personagem.

### 2. Reduzir o atrito do cliente com auto-selecao do servidor
- Pular a necessidade manual de navegar na lista de servidores ajudou muito.

### 3. Confirmar tudo com `world.log` e screenshots
- Nesta thread, isso evitou confundir:
  - bug de UI
  - bug de clique
  - bug de serializacao
  - bug de servidor

### 4. Tratar a criacao e o pos-criacao como problemas diferentes
- A criacao em si funcionou.
- O bug restante passou a ser claramente o passo seguinte.
- Essa separacao economiza muito tempo de debug.

## Armadilhas para evitar no rebuild

### 1. Nao reabrir auth/launcher depois que a tela de personagem ja apareceu
- Nesta thread, quando a tela de personagem apareceu e o `CharacterCreationRequestMessage` chegou no servidor, o foco correto deixou de ser auth.

### 2. Nao confundir `7121` com `CharacterSelectionMessage`
- Nesta thread isso gerou analise errada em uma etapa.
- O alinhamento correto aqui foi:
  - `7121 = ServerSelectionMessage`

### 3. Nao confiar so no source alterado; confirmar se o binario novo esta realmente rodando
- Este foi o ponto mais importante no final da thread.
- O source do `CharacterHandler.cs` foi corrigido para nao chamar `ProcessSelection(client)` imediatamente.
- Porem, o `world.log` do teste seguinte ainda mostrou o comportamento antigo:
  - `ProcessSelection sending CharacterSelectedSuccess ...`
- Interpretacao assertiva:
  - o servidor rodando no teste ainda estava usando binario antigo/stale
  - antes de qualquer nova teoria, era preciso reiniciar e garantir runtime com o build novo

### 4. Nao insistir em automacao cega se a deteccao da tela estiver errada
- O helper chegou a falhar dizendo que a tela nao era `CUSTOMISE` quando era.
- Corrigir o detector foi melhor do que repetir clique varias vezes.

## Estado final exato desta thread
- O cliente chegava na tela `CUSTOMISE`.
- O nome do personagem estava preenchido como `Solougtyh` em um dos testes documentados.
- O clique em `Play` era aceito pelo fluxo de teste.
- O `world.log` mostrava criacao bem-sucedida do personagem.
- O proximo bug ficou reduzido para o passo imediatamente apos essa criacao.
- O ultimo fato novo importante foi:
  - a correcao de source do `CharacterHandler.cs` ainda nao estava refletida no processo vivo do `World`
  - portanto o proximo passo correto nao era mais uma mudanca logica grande
  - era garantir que o processo em execucao estivesse usando o build novo

## Proximo passo recomendado se for reconstruir esta linha de trabalho
1. Reaplicar no rebuild apenas o necessario para voltar a:
   - `ServerId = 36`
   - fluxo `Abrir Dofus Solo.cmd -> Jogar Agora`
   - tela de criacao/customizacao
2. Reaplicar o patch que auto-seleciona servidor `36` no cliente, se esse comportamento continuar desejado.
3. Reconfirmar com log que o `CharacterCreationRequestMessage` chega no `World`.
4. No pos-criacao:
   - evitar selecao automatica imediata do personagem
   - testar o caminho de atualizar lista / deixar o cliente decidir o proximo passo
5. Antes de concluir qualquer correcao no world:
   - garantir que o processo rodando usa o binario rebuildado
   - nao confiar so em `dotnet build` sem reinicio/runtime validado

## Artefatos uteis desta thread
- `N:\Codex_Programs\Dofus 2 private\runtime\auth.log`
- `N:\Codex_Programs\Dofus 2 private\runtime\world.log`
- `N:\Codex_Programs\Dofus 2 private\runtime\auth-debug-notes-2026-04-05.md`
- `N:\Codex_Programs\Dofus 2 private\runtime\Drive-DofusUi.ps1`
- `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260405-170045-575-capture.png`
- `N:\Codex_Programs\Dofus 2 private\runtime\ui-20260405-170218-098-after-click-play.png`

## Resumo curto para merge futuro
- Esta thread levou o projeto alem do auth/launcher e colocou o fluxo local na tela de criacao de personagem.
- `ServerId = 36` e `7121 = ServerSelectionMessage` foram achados importantes.
- O request de criacao de personagem passou a funcionar e o servidor criou o personagem com sucesso.
- O bug restante foi reduzido ao pos-criacao.
- O ultimo achado critico foi operacional:
  - havia forte indicio de binario antigo do `World` ainda em execucao
  - antes de qualquer nova mudanca grande, o rebuild novo precisa garantir runtime limpo com o binario correto
