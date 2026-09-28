{ user, ... }:
{
  imports = [
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/update.nix
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

  networking.hostName = "hyrule";
  networking.computerName = "hyrule";
  networking.localHostName = "hyrule";

  system.primaryUser = user;
  users.users.${user}.home = "/Users/${user}";

  programs.zsh.enable = true;

  system.stateVersion = 6;
}
