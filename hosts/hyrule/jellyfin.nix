{ user, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  # Media library: gbueno copies files in (mediasync on kokiri), Jellyfin only reads them
  systemd.tmpfiles.rules = [
    "d /srv/media 0755 ${user} users -"
    "d /srv/media/movies 0755 ${user} users -"
    "d /srv/media/shows 0755 ${user} users -"
  ];
}
