{
  config,
  lib,
  pkgs,
  ...
}:
let
  src = "${config.home.homeDirectory}/Hyrule/Jellyfin/media";
  log = "${config.home.homeDirectory}/Library/Logs/mediasync.log";

  # mediasync: move finished downloads to hyrule:/srv/media, freeing space here
  mediasync = pkgs.writeShellApplication {
    name = "mediasync";
    runtimeInputs = [ pkgs.rsync ];
    text = ''
      src="${src}"
      dest="hyrule:/srv/media"
    ''
    + builtins.readFile ../scripts/mediasync.sh;
  };
in
{
  home.packages = [ mediasync ];

  # Runs when something lands in the folders, and every 10 minutes to retry
  # (for example, when hyrule was off)
  launchd.agents.mediasync = {
    enable = true;
    config = {
      ProgramArguments = [ (lib.getExe mediasync) ];
      WatchPaths = [
        "${src}/movies"
        "${src}/shows"
      ];
      StartInterval = 600;
      RunAtLoad = true;
      StandardOutPath = log;
      StandardErrorPath = log;
    };
  };

  # launchd only watches folders that exist
  home.activation.mediasyncFolders = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run mkdir -p "${src}/movies" "${src}/shows"
  '';
}
