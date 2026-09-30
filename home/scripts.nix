{ config, pkgs, ... }:
let
  platform = pkgs.stdenv.hostPlatform;
  flake = "${config.home.homeDirectory}/dotfiles";
  rebuild = if platform.isDarwin then "darwin-rebuild" else "nixos-rebuild";
  defaultHost = if platform.isDarwin then "macbook" else "$(hostname)";

  # nxr: apply the current config (versions pinned by flake.lock)
  nxr = pkgs.writeShellApplication {
    name = "nxr";
    text = ''
      flake="${flake}"
      rebuild="/run/current-system/sw/bin/${rebuild}"
      default_host="${defaultHost}"
    ''
    + builtins.readFile ../scripts/nixrebuild.sh;
  };

  # nxu: update flake inputs and Homebrew, then apply with nxr
  nxu = pkgs.writeShellApplication {
    name = "nxu";
    runtimeInputs = [ nxr ];
    text = ''
      flake="${flake}"
    ''
    + builtins.readFile ../scripts/nixupdate.sh;
  };
in
{
  assertions = [
    {
      assertion = platform.isDarwin -> platform.isAarch64;
      message = "nxr: macOS hosts must be aarch64 (Apple Silicon)";
    }
  ];

  home.packages = [
    nxr
    nxu
  ];
}
