{
  config,
  lib,
  user,
  ...
}:
let
  jellyfin = config.services.jellyfin.user;
in
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # Shared "media" group: gbueno copies files in (mediasync on kokiri),
  # Jellyfin writes downloaded subtitles next to them
  users.groups.media = { };
  users.users.${user}.extraGroups = [ "media" ];
  users.users.${jellyfin}.extraGroups = [ "media" ];

  # Files Jellyfin creates are group-writable (the module defaults to 0077)
  systemd.services.jellyfin.serviceConfig.UMask = lib.mkForce "0007";

  # setgid (2): everything created inside inherits the media group
  systemd.tmpfiles.rules = [
    "d /srv/media 2775 ${user} media -"
    "d /srv/media/movies 2775 ${user} media -"
    "d /srv/media/shows 2775 ${user} media -"
  ];
}
