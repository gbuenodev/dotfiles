# dotfiles

Configuração do Mac (`kokiri`, nix-darwin) e do homelab (`hyrule`, NixOS) com Nix flakes e home-manager. O `README.md` descreve o repositório; `docs/` documenta cada sistema.

## Regra: explicar passo a passo

Este projeto também serve para aprender Nix e o sistema. Em toda mudança:

- Explique cada passo antes ou junto com a mudança: o que está sendo feito, por quê e o que cada opção nova significa.
- Diga de onde vem cada opção (nix-darwin, home-manager, nixpkgs, flake) e o que acontece no sistema quando ela é aplicada.
- Mostre os comandos de verificação e o que se espera ver.
- Prefira mudanças pequenas e verificáveis a várias coisas de uma vez.
- O usuário escreve os arquivos de configuração no nvim (neovim), para praticar. Nos comandos de edição, use `nvim`. Mostre o conteúdo e onde colocá-lo, e não edite esses arquivos diretamente; depois, confira o que foi escrito (parse, build, diff).

## Convenções

- Apps gráficos: casks do Homebrew, declarados em `modules/darwin/homebrew.nix`. Exceção: quando não há cask utilizável (o do qBittorrent foi desativado), o app vem do nixpkgs.
- Ferramentas de terminal: Nix (home-manager ou nixpkgs), iguais no Mac e no homelab.
- Responsabilidades: o Nix gerencia pacotes e sistema; as configs das ferramentas são responsabilidade do usuário. Elas ficam como arquivos nativos em `config/<app>/`, versionadas pelo git e ligadas pelo home-manager com `mkOutOfStoreSymlink` (sem `settings` no Nix). O rollback do Nix não as desfaz; o histórico delas é o git.
- Módulos `programs.*` do home-manager continuam úteis para instalar e integrar (por exemplo, o `starship init` no zsh). No Mac, `package = null` quando o app vem do cask.
- Módulos do home-manager ficam em `home/`; os compartilhados são importados por `home/default.nix`, e os de uma máquina só, por `hosts/<máquina>/home.nix`.
- Nome no flake = hostname.
- Formatação: `nix fmt` (nixfmt-tree).
- Aplicar a config (versões do `flake.lock`): `nxr`.
- Atualizar tudo (flake inputs + Homebrew) e aplicar: `nxu`.

## Contexto

O `README.md` (estrutura e uso do repo) e o `docs/` (`home.md`, `kokiri.md`, `hyrule.md`, `media.md`) descrevem o estado atual: ao mudar uma máquina, a estrutura ou um fluxo, atualize o documento correspondente na mesma mudança. Pendências e o andamento ficam na memória do Claude, não no repo.
