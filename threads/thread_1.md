# Notas de Rebuild - Escopo Desta Thread

## Escopo deste arquivo
- Este arquivo registra apenas o que foi descoberto, validado ou alterado nesta thread.
- Nao mistura conclusoes de outras threads.
- O foco aqui e o problema do cliente abrir, mostrar janela, mas falhar com a mensagem de autenticacao do servidor.

## Objetivo que esta thread perseguia
- Fazer o cliente Dofus 2.63.9.16 abrir de forma visivel.
- Garantir que ele passasse do launcher/Zaap local.
- Fazer o cliente aceitar o servidor local em vez de parar em erro de autenticacao.

## Resultado real obtido nesta thread
- O problema de janela invisivel deixou de ser o bloqueio principal.
- O cliente passou a abrir visivelmente.
- O novo bloqueio identificado com evidencia foi:
  - `The connection has failed. The server could not be authenticated`
- Esse bloqueio acontece no cliente antes do login real no `Auth` local.

## O que foi comprovado com evidencia
### 1. O launcher/Zaap local estava respondendo
- O cliente chegou a conversar com o `Zaap` local.
- Logs do launcher mostravam estados como `Handshake=True` em alguns launches.
- Arquivo util para confirmar isso:
  - `N:\Codex_Programs\Dofus 2 private\runtime\client-launch.log`

### 2. O cliente abriu a janela do jogo
- Isso eliminou o bug principal anterior de launch invisivel como causa raiz atual.
- O print do usuario mostrou a tela do jogo com o popup:
  - `The server could not be authenticated`

### 3. O `Auth` local nao era o primeiro bloqueio nessa etapa
- O cliente ainda nao estava chegando de forma util no `Auth` local no ponto do erro.
- Portanto, insistir primeiro em parser de login/token sem resolver o cliente confiando no host provavelmente desperdicaria tempo.

### 4. O `config.xml` local ja estava apontando para localhost
- Arquivo:
  - `N:\Dofus263\client-2.63.9.16-en\config.xml`
- Campos vistos nesta thread:
  - `connection.host = 127.0.0.1`
  - `connection.host.signature = <assinatura oficial antiga>`
- Conclusao importante:
  - O host foi trocado para local, mas a assinatura continuou a oficial.
  - Isso bate com o erro de host nao autenticado.

### 5. O ponto exato do bloqueio foi localizado dentro do cliente
- Ferramenta instalada nesta thread:
  - `C:\Program Files (x86)\FFDec\ffdec-cli.exe`
- Arquivo do cliente analisado:
  - `N:\Dofus263\client-2.63.9.16-en\DofusInvoker.swf`
- A exportacao parcial gerada ficou em:
  - `N:\Codex_Programs\Dofus 2 private\runtime\ffdec-export\scripts`
- Arquivo mais importante encontrado:
  - `N:\Codex_Programs\Dofus 2 private\runtime\ffdec-export\scripts\com\ankamagames\dofus\logic\connection\frames\AuthentificationFrame.pcode`

## Prova tecnica mais importante desta thread
No arquivo `AuthentificationFrame.pcode`, foram encontrados estes textos:
- `config.connection.host.signature`
- `ui.popup.connectionFailed.unauthenticatedHost`
- `Host signature could not be verified, connection refused.`

Trecho-chave observado:
```text
getscopeobject 1
getslot 34
iftrue ofs047b
...
pushstring "Host signature could not be verified, connection refused."
...
pushfalse
returnvalue
ofs047b:
```

## Interpretacao assertiva
- O cliente tem uma verificacao explicita de assinatura do host.
- Quando a verificacao falha, ele mostra exatamente o erro visto pelo usuario.
- Isso significa que, neste ponto da investigacao, o proximo passo mais promissor nao era continuar mexendo em UI, launch ou assets.
- O proximo passo correto era patchar essa verificacao do cliente ou gerar uma assinatura aceita.

## Mudancas de codigo feitas nesta thread antes de chegar nesse diagnostico
Estas mudancas existem no projeto original `N:\Codex_Programs\Dofus 2 private` e podem servir de referencia para o rebuild, mas o rebuild novo deve reaplicar com criterio e na menor escala possivel.

### Fluxo de launcher e cliente
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\ClientLaunchService.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\SoloLauncherService.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\AppState.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\LauncherPaths.cs`

### Fluxo de Zaap/protocolo/token
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\Protocol\MessagesHandler.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\Protocol\SettingsGetResult.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\Protocol\AuthGetGameTokenResult.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\Protocol\UserInfosGetResult.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Core\Authentication\LauncherTokenCodec.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Auth\Handlers\ConnectionHandler.cs`

### Race/recebimento de rede
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Core\Network\TcpClient.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Auth\Network\AuthClient.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Auth\Network\IPC\IPCClient.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.World\Network\WorldClient.cs`
- `N:\Codex_Programs\Dofus 2 private\GinyCore\Giny.Zaap\Network\ZaapClient.cs`

### Script de cliente
- `N:\Codex_Programs\Dofus 2 private\scripts\Ensure-Dofus263Client.ps1`
- `N:\Codex_Programs\Dofus 2 private\Abrir Dofus Solo.cmd`

## O que deu certo e vale repetir no rebuild
### 1. Separar o problema visual do problema de autenticacao
- Primeiro o projeto parecia ter bug de launch invisivel.
- Depois a evidencia mostrou que a janela ja abria.
- Isso evitou continuar perdendo tempo no lugar errado.

### 2. Confiar em log, payload e arquivo real mais do que em impressao visual
- O print do usuario ajudou muito, mas o fechamento do diagnostico veio do `config.xml`, logs e `DofusInvoker.swf`.

### 3. Instalar a ferramenta certa em vez de tentar engenharia reversa cega na mao
- Instalar o `FFDec` foi a decisao correta.
- Isso e muito melhor do que editar bytes aleatorios no SWF sem contexto.

### 4. Encontrar a mensagem do erro dentro do SWF
- Pesquisar a string exata do popup foi o caminho mais eficiente para achar o bloco de verificacao.

## Armadilhas para evitar no rebuild
### 1. Nao assumir que `Handshake=True` significa que o jogo esta pronto
- Nesta thread houve launch com janela visivel e handshake no launcher, mas o cliente ainda falhava na autenticacao do servidor.

### 2. Nao atacar logo o `Auth` se o cliente nem confia no host ainda
- Se o cliente esta recusando o host por assinatura, gastar tempo em parser de token pode virar debug falso.

### 3. Nao trocar varias pecas grandes ao mesmo tempo
- Evitar refatoracao ampla em launcher, cliente, auth e world tudo junto.
- O melhor caminho aqui foi reduzir o problema ate um bloco especifico dentro do SWF.

### 4. Nao confiar que mudar so `connection.host` basta
- Mudar `connection.host` para `127.0.0.1` sem tratar `connection.host.signature` deixa o cliente bloqueado.

### 5. Nao tratar export incompleta do FFDec como prova de falha
- A exportacao completa demorou e chegou a estourar timeout no terminal.
- Mesmo assim a exportacao parcial ja trouxe o arquivo critico `AuthentificationFrame.pcode` com o trecho necessario.

## Proximo passo recomendado se for reconstruir esta linha de trabalho
### Objetivo
- Fazer o cliente parar de rejeitar o host local por assinatura.

### Passo a passo minimo
1. Fazer backup de:
   - `N:\Dofus263\client-2.63.9.16-en\DofusInvoker.swf`
2. Garantir que o `FFDec` esteja instalado:
   - `C:\Program Files (x86)\FFDec\ffdec-cli.exe`
3. Exportar scripts do SWF se necessario.
4. Abrir ou localizar o arquivo:
   - `...\AuthentificationFrame.pcode`
5. No bloco da verificacao de host, testar o patch minimo:
   - trocar `iftrue ofs047b` por `iffalse ofs047b`
6. Reimportar os scripts para um novo SWF.
7. Substituir o `DofusInvoker.swf` com backup salvo.
8. Retestar o cliente.
9. So depois disso verificar se o proximo bloqueio virou token/login no `Auth`.

## Patch que estava planejado por esta thread
Patch minimo proposto:
```text
De:
iftrue ofs047b

Para:
iffalse ofs047b
```

## Motivo do patch planejado
- E o menor delta no ponto exato da falha.
- Mantem a pilha do AVM2 consistente.
- Mira diretamente o branch que abre o popup de host nao autenticado.

## Comando util ja identificado para reimportar
Este comando precisava ser validado na pratica pela proxima etapa, mas este era o caminho previsto:
```powershell
& 'C:\Program Files (x86)\FFDec\ffdec-cli.exe' `
  -onerror abort `
  -importScript `
  'N:\Dofus263\client-2.63.9.16-en\DofusInvoker.swf' `
  'N:\Dofus263\client-2.63.9.16-en\DofusInvoker.patched.swf' `
  'N:\Codex_Programs\Dofus 2 private\runtime\ffdec-export\scripts'
```

## Artefatos uteis desta thread
- `N:\Codex_Programs\Dofus 2 private\runtime\client-launch.log`
- `N:\Codex_Programs\Dofus 2 private\runtime\auth.log`
- `N:\Codex_Programs\Dofus 2 private\runtime\world.log`
- `N:\Codex_Programs\Dofus 2 private\runtime\ffdec-export\scripts\com\ankamagames\dofus\logic\connection\frames\AuthentificationFrame.pcode`

## Resumo curto para merge futuro
- Esta thread provou que o bloqueio principal deixou de ser UI/launch e passou a ser a validacao de host assinado no cliente.
- O ponto exato foi localizado dentro de `DofusInvoker.swf`, em `AuthentificationFrame.pcode`.
- O patch minimo planejado foi inverter o branch `iftrue ofs047b` para `iffalse ofs047b` antes de qualquer nova rodada grande de debug em `Auth`.
