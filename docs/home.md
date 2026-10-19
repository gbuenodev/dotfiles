# Ambiente do usuário

Módulos do home-manager em `home/`, importados por `home/default.nix` nas duas máquinas. Os módulos só de uma máquina são importados por `hosts/<máquina>/home.nix`.

| Ferramenta | Módulo | Config |
|---|---|---|
| zsh | `home/zsh.nix` | `config/zsh/zshenv`, `config/zsh/zshrc` |
| Starship | `home/starship.nix` | `config/starship/<hostname>.toml` |
| Neovim, ripgrep, fd | `home/nvim.nix` | `config/nvim/` |
| SSH | `home/ssh.nix` | `config/ssh/config` |
| `nxr`, `nxu` | `home/scripts.nix` | `scripts/nixrebuild.sh`, `scripts/nixupdate.sh` |

## zsh

- O home-manager gera o `~/.zshenv` e o `~/.zshrc`, que carregam os arquivos de `config/zsh/` no final.
- Plugins: autosuggestion, syntax highlighting e history substring search.
- `~/.zshenv.local`, se existir, é carregado no fim do `zshenv`. Serve para variáveis de uma máquina só, que não vão para o repo.

## Starship

- Cada máquina usa o próprio arquivo: o `home/starship.nix` escolhe `config/starship/<hostname>.toml` pelo `osConfig.networking.hostName`.
- O layout é o mesmo nos dois arquivos (duas linhas, inspirado no tema gnzh do oh-my-zsh), e só muda a paleta no fim: Kokiri Forest no kokiri, com os verdes do Everforest, e Hyrule Field no hyrule, em tons de azul. A diferença de cor mostra em que máquina você está.
- Para mudar o layout, edite os dois arquivos.

## Neovim

- lazy.nvim com kanagawa, telescope e which-key. As versões ficam fixadas em `config/nvim/lazy-lock.json`.
- `Space ?` abre o `config/nvim/CHEATSHEET.md`.
- Contas que não podem escrever no repo (o `suaquadra`) usam uma cópia do lockfile em `~/.local/share/nvim/lazy-lock.json`, refeita a cada início, porque o lazy.nvim reescreve o lockfile depois de cada instalação.
- Servidores LSP, quando houver, vêm do Nix, e não do Mason.

## SSH

- `~/.ssh/config` é um link para `config/ssh/config`.
- `ssh hyrule` vai para `gbueno@hyrule.local`.

## nxr e nxu

- **`nxr [host]`:** roda `darwin-rebuild` ou `nixos-rebuild switch --flake ~/dotfiles#<host>`. Por padrão, o host é a máquina atual.
- **`nxu`:** roda `nix flake update`, depois `nxr`, depois `brew update && brew upgrade`. Como chama o `brew` sem conferir, por enquanto só funciona no kokiri.
