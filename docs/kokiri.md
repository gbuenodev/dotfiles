# kokiri

MacBook Apple Silicon (`aarch64-darwin`), macOS com nix-darwin. É a máquina de uso diário; o nome vem da floresta onde o Link mora.

- Sistema: `hosts/kokiri/default.nix`, `modules/darwin/`
- home-manager só do Mac: `hosts/kokiri/home.nix`
- Conta de trabalho (`suaquadra`): `hosts/kokiri/suaquadra.nix`, módulo independente importado pelo `flake.nix`. Para removê-la, apague o arquivo e a linha dele no `flake.nix`
- Na rede: `kokiri.local`

## Sistema (nix-darwin)

- Hostname, ComputerName e LocalHostName: `kokiri`.
- Touch ID no `sudo`.
- `nix.gc` aos domingos às 3h, apagando gerações com mais de 30 dias, e `nix.optimise` automático.
- ⌘Espaço liberado do Spotlight para o Raycast (`modules/darwin/hotkeys.nix`, entrada 64 do `AppleSymbolicHotKeys`).

## Homebrew

`modules/darwin/homebrew.nix`. Casks: cmux, dbeaver-community, ghostty e raycast.

- `autoUpdate` e `upgrade` desligados: o rebuild não mexe nas versões; quem atualiza é o `nxu`.
- `cleanup = "none"`: pacotes instalados fora do repo não são removidos.
- Se o `brew bundle` falhar, a ativação para ali e o home-manager não roda. Já aconteceu com o cask do Raycast e com o do qBittorrent.

## Apps (home-manager)

| App | Origem | Config |
|---|---|---|
| Ghostty | cask; o módulo só liga a config (`package = null`) | `config/ghostty/config` |
| cmux | cask | `config/cmux/cmux.json` |
| qBittorrent | nixpkgs, porque o cask foi desativado (falha no Gatekeeper) | no próprio app |
| mediasync | `home/mediasync.nix` | ver [Mídia](media.md) |

- **Ghostty:** tema Kanagawa Wave, fonte 18, abas na barra de título (`macos-titlebar-style = tabs`). Atalhos com a Hyper Key (Caps Lock pelo Raycast = `ctrl+alt+shift+super`) para abas, splits e tamanho da fonte. O `suaquadra` usa o mesmo arquivo, gerenciado por um home-manager próprio que só tem o Ghostty.
- **Apps do Nix:** aparecem em `~/Applications/Home Manager Apps/` (`targets.darwin.linkApps`).

## Fora do repo

- **`~/.zshenv.local`:** variáveis desta máquina.
- **Permissão de Rede Local** (Ajustes do Sistema → Privacidade e Segurança → Rede Local). Sem ela, `ssh` e `rsync` para `192.168.x.x` falham com `No route to host`. O Ghostty já tem; o cmux ainda não. O nix-darwin não consegue declarar essa permissão.
- **Gerenciamento de Apps** (Privacidade e Segurança). O terminal que roda o `nxr` precisa dessa permissão para o Homebrew substituir um app que foi instalado à mão.
