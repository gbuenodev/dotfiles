{ user, ... }:
{
  imports = [
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/hotkeys.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 3;
      Minute = 0;
    };
    options = "--delete-older-than 30d";
  };
  nix.optimise.automatic = true;

  security.pam.services.sudo_local.touchIdAuth = true;

  networking.hostName = "kokiri";
  networking.computerName = "kokiri";
  networking.localHostName = "kokiri";

  system.primaryUser = user;
  users.users.${user}.home = "/Users/${user}";

  programs.zsh.enable = true;
  programs.zsh.enableGlobalCompInit = false;

  system.stateVersion = 6;
}
