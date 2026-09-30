host="${1:-$default_host}"
shift || true

echo "==> $rebuild switch --flake $flake#$host $*"
exec sudo "$rebuild" switch --flake "$flake#$host" "$@"
