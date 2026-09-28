{ pkgs, user, ... }:
{
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "dotfiles-update" ''
      set -euo pipefail
      cd /Users/${user}/dotfiles

      echo "==> Atualizando flake.lock"
      nix flake update

      echo "==> Aplicando a configuração"
      sudo /run/current-system/sw/bin/darwin-rebuild switch --flake .#macbook

      echo "==> Atualizando Homebrew"
      /opt/homebrew/bin/brew update
      /opt/homebrew/bin/brew upgrade
    '')
  ];
}
