{ config, osConfig, ... }:
{
  programs.starship.enable = true;

  # Each host has its own theme: config/starship/<hostname>.toml
  xdg.configFile."starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/config/starship/${osConfig.networking.hostName}.toml";
}
