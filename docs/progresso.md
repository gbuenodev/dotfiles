# Progresso

Diário de bordo da configuração. Atualizar ao fim de cada sessão de trabalho.

## Estado atual (2026-10-17)

Duas máquinas, no tema Zelda: o Mac é o **`kokiri`** (a casa do Link) e o homelab é o **`hyrule`** (o primeiro mundo que ele explora).

### kokiri (Mac, `darwinConfigurations.kokiri`, `hosts/kokiri/`)

Módulos do home-manager só do Mac (Ghostty, cmux) ficam em `hosts/kokiri/home.nix`; o `home/` tem o que é compartilhado com o hyrule (zsh, starship, nvim, ssh, scripts). `~/.ssh/config` vem de `config/ssh/config` (atalho `ssh hyrule`).

Completo; aplica sem erros com `nxr`.

- **Sistema (nix-darwin):** Touch ID no `sudo`, `nix-gc` semanal e `nix-optimise`, hostname `kokiri` (`kokiri.local` na rede), ⌘Espaço liberado do Spotlight para o Raycast (`modules/darwin/hotkeys.nix`).
- **Homebrew:** casks `cmux`, `dbeaver-community`, `ghostty` e `raycast`. O problema da adoção do `Raycast.app` foi resolvido; hoje o app é do `gbueno`.
- **home-manager:** zsh (`programs.zsh` com autosuggestion, syntax highlighting e history substring search), Starship, Ghostty, cmux, neovim (com ripgrep e fd) e os comandos `nxr`/`nxu`.
- **Configs nativas em `config/`** (ghostty, starship, zsh, nvim, cmux), ligadas com `mkOutOfStoreSymlink`. O `~/.zshrc` passou a ser gerado pelo home-manager e carrega o `config/zsh/zshrc`.
- **nvim:** lazy.nvim com kanagawa, telescope e which-key, além do `CHEATSHEET.md` aberto com `Space ?`.
- **Ghostty:** `font-size = 18`, `macos-titlebar-style = tabs`.

### hyrule (homelab, NixOS)

**Passos A e B concluídos.** NixOS instalado à mão pelo ISO minimal (26.05) e depois trazido para o flake: `nixosConfigurations.hyrule` em `hosts/hyrule/`, no mesmo `nixpkgs-unstable` do Mac (26.11), com o mesmo `home/`. O repo está clonado em `~/dotfiles` no hyrule (HTTPS, só leitura). Acesso: `ssh hyrule` (Avahi publica `hyrule.local`; IP atual `192.168.0.14`).

**Fluxo de mudança:** editar no kokiri, commitar e dar push; no hyrule, `git -C ~/dotfiles pull` e `nxr`. Para testar sem ativar: `nixos-rebuild build --flake ~/dotfiles#hyrule` (não precisa de sudo).

- **Hardware:** x86_64, Intel, 8 núcleos, 15 GiB de RAM, NVMe ADATA 512 GB (`nvme0n1`), Wi-Fi `wlp0s20f3`, UEFI.
- **Disco:** GPT com ESP de 1 GB (vfat, rótulo `BOOT`, `/boot`, `umask=077`) e o resto em btrfs (rótulo `nixos`), com os subvolumes `@` (`/`), `@home` (`/home`) e `@nix` (`/nix`), montados com `compress=zstd,noatime`. As opções de compressão ficam no `configuration.nix`, porque o `nixos-generate-config` só copia o `subvol=`.
- **Config (`hosts/hyrule/default.nix`):** systemd-boot, `zramSwap` (sem partição de swap), NetworkManager, fuso `America/Sao_Paulo`, usuário `gbueno` (`wheel`, `networkmanager`) com a chave `~/.ssh/id_ed25519.pub` do kokiri, OpenSSH só por chave e sem root, flakes ligados, zsh como shell (com `enableGlobalCompInit = false`), `git`, `neovim`, `ghostty.terminfo` e Avahi.
- **Nunca dorme:** `services.logind.settings.Login.HandleLidSwitch*` = `ignore` (bateria, carregador, dock) e os alvos `sleep`, `suspend`, `hibernate` e `hybrid-sleep` mascarados (`systemd.targets.*.enable = false`). O `nixos-rebuild switch` não reinicia o logind, então a mudança na tampa só valeu depois do reboot (conferir com `busctl get-property org.freedesktop.login1 ...`). Testado com a tampa fechada.
- **Ghostty via SSH:** sem a terminfo, programas com pager falham com `'xterm-ghostty': unknown terminal type` (contorno: `--no-pager` ou `TERM=xterm-256color`). Resolvido com `pkgs.ghostty.terminfo` nos pacotes.
- **Senhas fora do Nix:** a senha do `gbueno` foi definida com `nixos-enter` + `passwd` (só no `/etc/shadow`); o root está bloqueado (`--no-root-passwd`). A Wi-Fi é o `.nmconnection` copiado do live para `/etc/NetworkManager/system-connections/` (root, 600).

**Próximo:** definir o primeiro uso (passo C em diante, um serviço por vez).

## Histórico

- **2026-09-27:** casks do Homebrew, Touch ID, gc/optimise. O rebuild parou no cask do Raycast (proteção App Management do macOS).
- **2026-09-30:** zsh no home-manager, configs movidas para `config/`, neovim, `nxr`/`nxu` no lugar de `dotfiles-update`.
- **2026-10-16:** plugins do nvim, config do cmux, atalhos do Ghostty com a Hyper Key (Caps Lock).
- **2026-10-17:** mais atalhos do Telescope, cheatsheet ampliado, coassinaturas do Claude removidas do histórico, variáveis específicas da máquina movidas para o `~/.zshenv.local` (fora do repo), renomeação (Mac `hyrule` → `kokiri`, homelab = `hyrule`), Ghostty com fonte 18 e abas na barra de título, instalação do NixOS no `hyrule` (passo A), `hyrule` no flake com `home/` compartilhado, Avahi e `ssh hyrule` (passo B).

## Decisões tomadas

- **Nix gerencia pacotes e sistema; as configs das ferramentas são do usuário.** Ficam como arquivos nativos em `config/<app>/`, ligados com `mkOutOfStoreSymlink`, sem `settings` no Nix. O histórico delas é o git, não o rollback do Nix.
- **Apps gráficos via cask.** No Mac, `package = null` nos módulos do home-manager quando o app vem do cask.
- **Ferramentas de terminal via Nix**, iguais no Mac e no homelab.
- **Ghostty fica no cask**, não no Nix. No homelab, instalar só `pkgs.ghostty.terminfo`.
- **O rebuild não atualiza o Homebrew** (`autoUpdate` e `upgrade` desligados). Aplicar: `nxr`. Atualizar tudo (flake inputs + Homebrew) e aplicar: `nxu`.
- **`nxr` já prevê Linux:** usa `nixos-rebuild` e o `hostname` como host padrão fora do macOS.
- **`cleanup = "none"`** até terminar o inventário dos pacotes do Homebrew.
- **Formatação:** `nix fmt` (nixfmt-tree).
- **nvim:** lazy.nvim (não a distribuição LazyVim). Servidores LSP pelo Nix, sem Mason. Navegação de janelas no `Ctrl-w` padrão, sem remapear. Evitar atalhos com Alt (o teclado AULA 65 não tem).
- **Commits sem coassinatura do Claude.**
- **Tema do Starship por máquina:** `config/starship/<hostname>.toml`, escolhido em `home/starship.nix` pelo `osConfig.networking.hostName`. Os dois usam o mesmo layout gnzh de duas linhas e só mudam a paleta no fim do arquivo, como dica visual de que é outra máquina: kokiri = Kokiri Forest (cores do Everforest), hyrule = Hyrule Field (dourado, verde grama, azul céu). Mudar o layout exige editar os dois arquivos.
- **Nome no flake = hostname** (`darwinConfigurations.kokiri`, `nixosConfigurations.hyrule`), para o `nxr` e o `*-rebuild` acharem o host sozinhos.
- **hyrule:** btrfs com subvolumes `@`, `@home` e `@nix`; `zramSwap` em vez de partição de swap; SSH só por chave; senhas e Wi-Fi fora do Nix e do git.
- **hyrule usa o mesmo `nixpkgs-unstable` do Mac** por enquanto (um input, um `flake.lock`). Rever o canal estável quando houver serviços que não podem quebrar.
- **`/opt/homebrew`** era do `suaquadra` (uid 501); passou para o `gbueno` com `chown`.

## Pendências

### Homelab

- [ ] Definir o primeiro uso do `hyrule` (passo C em diante, um serviço por vez).
- [ ] `nxu` no hyrule: o `scripts/nixupdate.sh` roda `brew` sem conferir se existe; pôr um `if` para só rodar no Mac.
- [ ] Apagar o `/etc/nixos/` antigo do hyrule (já não é usado; o sistema vem do flake).
- [ ] `home/ghostty.nix` ainda tem o ramo Linux que instala o `pkgs.ghostty`; simplificar agora que ele é só do Mac.
- [ ] IP fixo (reserva no DHCP do roteador ou no NetworkManager), para o `192.168.0.14` não mudar.
- [ ] Mais tarde: controlar a rede Wi-Fi de casa pelo homelab (ainda não; esperar o usuário trazer).

### Mac

- [ ] Dar ao **cmux** a permissão de Rede Local (Ajustes → Privacidade e Segurança → Rede Local). Sem ela, `ssh` para `192.168.x.x` falha com `No route to host`; o Ghostty já tem. O nix-darwin não consegue declarar essa permissão.
- [ ] Adicionar `result` ao `.gitignore` (é o link deixado por `nix build`/`darwin-rebuild build`).
- [ ] Inventário do Homebrew. Ainda não declarado: o cask `session-manager-plugin`. Taps sem confiança: `hashicorp/tap`, `mongodb/brew`, `supabase/tap` (decidir `brew trust` ou `untap`). Apps instalados à mão em `/Applications` a virar casks: ChatGPT, Granola, Zed, Docker, Insomnia, balenaEtcher, Unity Hub, Spotify. Depois, `cleanup = "uninstall"`.
- [ ] Adotar o `nix-homebrew` com `autoMigrate = true` (passo separado).
- [ ] `direnv` e `nix-direnv`; substituir o gvm e o nvm por flakes por projeto.
- [ ] `system.defaults` (Dock, Finder, teclado).
- [ ] `programs.git`, `programs.ssh`, `fzf`, `zoxide` etc. no home-manager.

### nvim

- [ ] Confirmar se o `Ctrl-d` no Telescope funciona (foi relatado que "não funcionou"; talvez faltasse reiniciar o nvim).
- [ ] Próximos plugins: gitsigns + diffview, depois treesitter, LSP, conform e oil.nvim.

### Contas do Mac

- [ ] O `suaquadra` ainda está no grupo `admin`: `sudo dseditgroup -o edit -d suaquadra -t user admin`.
- [ ] Resíduos de contas apagadas no grupo `admin` (`teste` e o UUID órfão `316B8DCC-E5E3-4201-9AB5-EEC03E1B388C`), `/Users/Deleted Users/teste` e `/Library/Caches/Desktop Pictures`.
- [ ] Gerenciar o `suaquadra` pelo home-manager (exige config por usuário em vez do `user` único). As coisas de trabalho (taps, `session-manager-plugin`) vão para esse perfil.

