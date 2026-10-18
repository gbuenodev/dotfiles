# home-manager modules only for this Mac
{
  imports = [
    ../../home/ghostty.nix
    ../../home/cmux.nix
    ../../home/mediasync.nix
    ../../home/qbittorrent.nix
  ];

  # Apps from Nix (qBittorrent) are symlinked into ~/Applications/Home Manager Apps.
  # Explicit because newer stateVersions default to copyApps instead.
  targets.darwin.linkApps.enable = true;
}
