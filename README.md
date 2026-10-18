# dotfiles

Configuração declarativa das minhas máquinas com Nix flakes, nix-darwin, NixOS e home-manager.

| Máquina | Sistema | No flake |
|---|---|---|
| `kokiri` | MacBook Apple Silicon, macOS + nix-darwin | `darwinConfigurations.kokiri` |
| `hyrule` | servidor doméstico x86_64, NixOS | `nixosConfigurations.hyrule` |

## Estrutura

```
flake.nix          entradas e definição de cada máquina
hosts/<máquina>/   o que é específico de uma máquina (sistema e home.nix)
modules/darwin/    módulos do nix-darwin
home/              módulos do home-manager
config/<app>/      configs nativas das ferramentas, ligadas com mkOutOfStoreSymlink
scripts/           scripts shell, instalados como comandos
docs/              documentação de cada sistema
```

O Nix instala pacotes e configura o sistema. As configs das ferramentas ficam em `config/` como arquivos nativos: o home-manager só cria o link, então editar não exige rebuild.

## Uso

```sh
nxr        # aplica a config da máquina atual (versões do flake.lock)
nxu        # atualiza os inputs do flake e o Homebrew, depois aplica
nix fmt    # formata os arquivos .nix
```

O flake só enxerga arquivos que o git conhece: rode `git add` em arquivos novos antes de aplicar.

## Documentação

- [Ambiente do usuário](docs/home.md): shell, prompt, editor e SSH, iguais nas duas máquinas
- [kokiri](docs/kokiri.md): o Mac
- [hyrule](docs/hyrule.md): o servidor
- [Mídia](docs/media.md): do torrent no Mac até o Jellyfin na TV
