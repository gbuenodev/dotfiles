{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.ghostty;

    settings = {
      font-size = 14;
      theme = "Noctis";
      macos-option-as-alt = true;
      window-save-state = "always";
      confirm-close-surface = false;

      keybind = [
        "super+d=new_split:right"
        "super+shift+d=new_split:down"
        "super+ctrl+h=goto_split:left"
        "super+ctrl+j=goto_split:bottom"
        "super+ctrl+k=goto_split:top"
        "super+ctrl+l=goto_split:right"
        "super+shift+enter=toggle_split_zoom"
      ];
    };
  };
}
