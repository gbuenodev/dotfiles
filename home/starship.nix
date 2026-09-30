{ config, ... }:
{
  programs.starship.enable = true;

  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/starship/starship.toml";
}
