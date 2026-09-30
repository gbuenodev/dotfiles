{
  config,
  lib,
  pkgs,
  ...
}:
let
  zshConfig = "${config.home.homeDirectory}/dotfiles/config/zsh";
in
{
  programs.zsh = {
    enable = true;

    # Plugins installed and loaded by home-manager
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    # User config lives in config/zsh and is sourced last
    envExtra = ''
      [[ -r ${zshConfig}/zshenv ]] && source ${zshConfig}/zshenv
    '';
    initContent = lib.mkOrder 2000 ''
      [[ -r ${zshConfig}/zshrc ]] && source ${zshConfig}/zshrc
    '';

    profileExtra = lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  home.packages = [ pkgs.zsh-completions ];
}
