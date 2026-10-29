{
  config,
  osConfig,
  user,
  ...
}:
let
  # The repo lives in ${user}'s home, also when another account uses this module
  dotfiles = "${osConfig.users.users.${user}.home}/dotfiles";
in
{
  # Ghostty itself is gone, but cmux embeds it (libghostty) and reads this
  # file for theme, font and keybinds.
  xdg.configFile."ghostty/config".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/config/ghostty/config";
}
