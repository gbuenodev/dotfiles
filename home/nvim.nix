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
  home.packages = with pkgs; [
    neovim
    ripgrep
    fd
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/nvim";
}
