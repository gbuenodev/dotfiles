echo "==> nix flake update"
nix flake update --flake "$flake"

nxr "$@"

echo "==> brew update && brew upgrade"
/opt/homebrew/bin/brew update
/opt/homebrew/bin/brew upgrade
