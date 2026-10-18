{ pkgs, ... }:
{
  # From nixpkgs, not a cask: Homebrew disabled the qbittorrent cask on
  # 2026-09-01 because it fails the Gatekeeper check
  home.packages = [ pkgs.qbittorrent ];
}
