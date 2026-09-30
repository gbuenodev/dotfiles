{ pkgs, user, ... }:
{
  imports = [
    ./ghostty.nix
    ./zsh.nix
  ];

  home.username = user;
  home.homeDirectory =
    if pkgs.stdenv.hostPlatform.isDarwin then "/Users/${user}" else "/home/${user}";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
