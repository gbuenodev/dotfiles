# kokiri

MacBook Apple Silicon (`aarch64-darwin`), macOS com nix-darwin. É a máquina de uso diário; o nome vem da floresta onde o Link mora.

- Sistema: `hosts/kokiri/default.nix`, `modules/darwin/`
- home-manager só do Mac: `hosts/kokiri/home.nix`
- Conta de trabalho (`suaquadra`): `hosts/kokiri/suaquadra.nix`, módulo independente importado pelo `flake.nix`. Tem um home-manager próprio só com a config do Ghostty (lida pelo cmux) e o Neovim, que usam os mesmos arquivos do repo do `gbueno`. Para removê-la, apague o arquivo e a linha dele no `flake.nix`
- Na rede: `kokiri.local`

## Sistema (nix-darwin)

- Hostname, ComputerName e LocalHostName: `kokiri`.
- Touch ID no `sudo`.
- `nix.gc` aos domingos às 3h, apagando gerações com mais de 30 dias, e `nix.optimise` automático.
- ⌘Espaço liberado do Spotlight para o Raycast (`modules/darwin/hotkeys.nix`, entrada 64 do `AppleSymbolicHotKeys`).

## Homebrew

`modules/darwin/homebrew.nix`. Casks: cmux, dbeaver-community e raycast.

- `autoUpdate` e `upgrade` desligados: o rebuild não mexe nas versões; quem atualiza é o `nxu`.
- `cleanup = "none"`: pacotes instalados fora do repo não são removidos.
- Se o `brew bundle` falhar, a ativação para ali e o home-manager não roda. Já aconteceu com o cask do Raycast e com o do qBittorrent.

## Apps (home-manager)

| App | Origem | Config |
|---|---|---|
| cmux | cask | `config/cmux/cmux.json` e `config/ghostty/config` |
| qBittorrent | nixpkgs, porque o cask foi desativado (falha no Gatekeeper) | no próprio app |
| mediasync | `home/mediasync.nix` | ver [Mídia](media.md) |

- **cmux:** o terminal é o Ghostty embutido (libghostty), que lê o `~/.config/ghostty/config` (`home/ghostty.nix`): tema Kanagawa Wave, fonte 18 e atalhos com a Hyper Key (Caps Lock pelo Raycast = `ctrl+alt+shift+super`). Depois de editar, `cmux reload-config`. O `cmux.json` guarda o resto (barra lateral, atalhos do próprio cmux).
- **Apps do Nix:** aparecem em `~/Applications/Home Manager Apps/` (`targets.darwin.linkApps`).

## Fora do repo

- **`~/.zshenv.local`:** variáveis desta máquina.
- **Permissão de Rede Local** (Ajustes do Sistema → Privacidade e Segurança → Rede Local). Sem ela, `ssh` e `rsync` para `192.168.x.x` falham com `No route to host`. O cmux ainda não tem. O nix-darwin não consegue declarar essa permissão.
- **Gerenciamento de Apps** (Privacidade e Segurança). O terminal que roda o `nxr` precisa dessa permissão para o Homebrew substituir um app que foi instalado à mão.
