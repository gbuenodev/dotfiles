# dotfiles

Configuração do Mac (e futuramente do homelab NixOS) com Nix flakes, nix-darwin e home-manager.

## Regra: explicar passo a passo

Este projeto também serve para aprender Nix e o sistema. Em toda mudança:

- Explique cada passo antes ou junto com a mudança: o que está sendo feito, por quê e o que cada opção nova significa.
- Diga de onde vem cada opção (nix-darwin, home-manager, nixpkgs, flake) e o que acontece no sistema quando ela é aplicada.
- Mostre os comandos de verificação e o que se espera ver.
- Prefira mudanças pequenas e verificáveis a várias coisas de uma vez.
- O usuário escreve os arquivos de configuração no nvim (neovim), para praticar. Nos comandos de edição, use `nvim`. Mostre o conteúdo e onde colocá-lo, e não edite esses arquivos diretamente; depois, confira o que foi escrito (parse, build, diff).

## Convenções

- Apps gráficos: casks do Homebrew, declarados em `modules/darwin/homebrew.nix`.
- Ferramentas de terminal: Nix (home-manager ou nixpkgs), iguais no Mac e no homelab.
- Responsabilidades: o Nix gerencia pacotes e sistema; as configs das ferramentas são responsabilidade do usuário. Elas ficam como arquivos nativos em `config/<app>/`, versionadas pelo git e ligadas pelo home-manager com `mkOutOfStoreSymlink` (sem `settings` no Nix). O rollback do Nix não as desfaz; o histórico delas é o git.
- Módulos `programs.*` do home-manager continuam úteis para instalar e integrar (por exemplo, o `starship init` no zsh). No Mac, `package = null` quando o app vem do cask.
- Formatação: `nix fmt` (nixfmt-tree).
- Aplicar a config (versões do `flake.lock`): `nxr`.
- Atualizar tudo (flake inputs + Homebrew) e aplicar: `nxu`.

## Estrutura

- `flake.nix`: entradas e a definição de cada máquina.
- `hosts/<máquina>/`: o que é específico de uma máquina.
- `modules/darwin/`: módulos do nix-darwin (sistema, só no Mac).
- `home/`: módulos do home-manager (usuário, compartilhados entre máquinas). Só arquivos `.nix`.
- `config/<app>/`: arquivos de config que não são Nix (por exemplo, `config/nvim/`), ligados com `mkOutOfStoreSymlink` para editar sem rebuild.
- `scripts/`: scripts shell puros com nomes descritivos (`nixrebuild.sh` → comando `nxr`, `nixupdate.sh` → comando `nxu`); o módulo em `home/scripts.nix` os instala com `writeShellApplication`.
- `secrets/`: apenas segredos criptografados (sops-nix/agenix), nunca em texto puro.

## Contexto

Antes de começar, leia `docs/progresso.md`: estado atual, decisões tomadas e pendências. Atualize-o ao fim de cada sessão.
