{ pkgs, user, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./jellyfin.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # btrfs: options merged with the subvol= ones from hardware-configuration.nix
  fileSystems = {
    "/".options = [
      "compress=zstd"
      "noatime"
    ];
    "/home".options = [
      "compress=zstd"
      "noatime"
    ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
  };

  zramSwap.enable = true;

  # Network
  networking.hostName = "hyrule";
  networking.networkmanager.enable = true;

  # mDNS: answer as hyrule.local on the LAN
  services.avahi = {
    enable = true;
    publish = {
      enable = true;
      addresses = true;
    };
    openFirewall = true;
  };

  time.timeZone = "America/Sao_Paulo";

  # User
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHkfyGHGp0ws9Ai9WPt+x+Sc3AdZ3ggy3iaX737thsYY gabrielsbueno@hotmail.com"
    ];
  };

  # zsh as login shell; home-manager runs compinit, so skip the global one
  programs.zsh.enable = true;
  programs.zsh.enableGlobalCompInit = false;

  # SSH: key only
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = [
    pkgs.git
    pkgs.neovim
    pkgs.ghostty.terminfo
    pkgs.rsync # receiving end of mediasync
  ];

  # Server: never suspend, even with the lid closed
  services.logind.settings.Login = {
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
  systemd.targets = {
    sleep.enable = false;
    suspend.enable = false;
    hibernate.enable = false;
    hybrid-sleep.enable = false;
  };

  system.stateVersion = "26.05";
}
