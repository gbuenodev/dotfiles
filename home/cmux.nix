{ config, ... }:
{
  # cmux is installed by the Homebrew cask (modules/darwin/homebrew.nix);
  # this module only links its config.
  xdg.configFile."cmux/cmux.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/cmux/cmux.json";
}
