{
  config,
  osConfig,
  pkgs,
  user,
  ...
}:
let
  # The repo lives in ${user}'s home, also when another account uses this module
  dotfiles = "${osConfig.users.users.${user}.home}/dotfiles";
in
{
  programs.ghostty = {
    enable = true;
    # On macOS, Ghostty is installed by the Homebrew cask (modules/darwin/homebrew.nix),
    # so null tells home-manager to install nothing and only manage the config.
    # On Linux (e.g. NixOS), there is no Homebrew, so install it from nixpkgs.
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;
  };

  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/ghostty/config";
}
