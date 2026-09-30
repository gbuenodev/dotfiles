{ lib, pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      size = 50000;
      save = 50000;
      extended = true;
    };

    shellAliases = {
      grep = "grep --color=auto";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        fpath=($HOME/.docker/completions $fpath)
      '')
      ''
        setopt interactive_comments auto_menu complete_in_word always_to_end

        zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
        zstyle ':completion:*' menu select
        zstyle ':completion:*' list-colors '''
        zstyle ':completion:*' special-dirs true

        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line
        bindkey '^[[3~' delete-char
      ''
    ];

    profileExtra = lib.optionalString pkgs.stdenv.hostPlatform.isDarwin ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "╭─$username$hostname $directory$git_branch$git_status\n╰─$character";
      right_format = "$cmd_duration$status";

      username = {
        show_always = true;
        format = "[$user]($style)";
        style_user = "bold green";
      };
      hostname = {
        ssh_only = false;
        format = "@[$hostname]($style)";
        style = "bold green";
      };
      directory = {
        style = "bold blue";
        truncate_to_repo = false;
        truncation_length = 100;
      };
      git_branch = {
        format = "[‹$branch›]($style)";
        style = "bold yellow";
      };
      character = {
        success_symbol = "[➤](bold green)";
        error_symbol = "[➤](bold red)";
      };
      status = {
        disabled = false;
        format = "[$status ↵]($style)";
      };
    };
  };

  home.packages = [ pkgs.zsh-completions ];

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/go/bin"
    "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  ];

  home.sessionVariables = {
    AWS_PROFILE = "nomaru-admin";
    CLICOLOR = "1";
  };
}
