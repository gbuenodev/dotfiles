# Mídia

Os arquivos baixados por torrent no kokiri vão sozinhos para o hyrule e aparecem no Jellyfin, que os entrega para a TV Samsung (Tizen).

```
qBittorrent (kokiri)
  → ~/Hyrule/Jellyfin/media/{movies,shows}
  → mediasync: rsync por SSH, apaga do Mac o que enviou
  → hyrule:/srv/media/{movies,shows}
  → Jellyfin (hyrule:8096)
  → TV
```

## qBittorrent (kokiri)

Instalado pelo nixpkgs (`home/qbittorrent.nix`). As preferências ficam no próprio app:

- **Downloads → Manter torrents incompletos em:** `~/Downloads/incompletos`. Sem isso, o `mediasync` envia arquivos pela metade.
- **Downloads → Modo de gerenciamento de torrents:** Automático, para a pasta de destino vir da categoria.
- **Categorias:** `Filmes` com destino `~/Hyrule/Jellyfin/media/movies`, e `Séries` com destino `~/Hyrule/Jellyfin/media/shows`.
- **BitTorrent → Limites de semeadura:** remover o torrent ao concluir. O `mediasync` tira o arquivo do Mac, e o torrent não consegue continuar semeando.

## mediasync (kokiri)

`scripts/mediasync.sh` e `home/mediasync.nix`.

- Envia `~/Hyrule/Jellyfin/media/` para `hyrule:/srv/media/` com `rsync -a --partial --remove-source-files --chmod=D0755,F0644`.
  - **`--partial`:** uma cópia interrompida continua de onde parou.
  - **`--remove-source-files`:** apaga do Mac só o que foi enviado. Depois, o script remove as pastas que ficaram vazias.
  - **`--chmod`:** os arquivos chegam com permissão de leitura para o Jellyfin.
- Se não houver nada a enviar, sai sem usar a rede.
- Um agente do launchd (`org.nix-community.home.mediasync`) roda o script quando algo muda em `movies/` ou `shows/`, a cada 10 minutos (para tentar de novo se o hyrule estiver desligado) e no login.
- Log: `~/Library/Logs/mediasync.log`. Para rodar à mão: `mediasync`.

## Jellyfin (hyrule)

`hosts/hyrule/jellyfin.nix`.

- **`services.jellyfin` com `openFirewall`:** abre o TCP 8096 (web e apps) e o 8920 (HTTPS), e o UDP 1900 e 7359 (descoberta na rede local).
- **Pastas:** `/srv/media`, `/srv/media/movies` e `/srv/media/shows`, do `gbueno`, com permissão 0755. Elas são criadas pelo `systemd.tmpfiles`.
- **Fora do Nix**, em `/var/lib/jellyfin`: usuário administrador, bibliotecas (`Filmes` → `/srv/media/movies`, `Séries` → `/srv/media/shows`) e idioma dos metadados (pt-BR). Tudo isso se configura pela interface web, em `http://hyrule.local:8096`.

## TV

- Instalar o app Jellyfin pela loja da Samsung. O servidor costuma aparecer sozinho; se não aparecer, use `http://192.168.0.14:8096`, porque a TV não resolve nomes `.local`.
- As Samsung mais novas não tocam áudio DTS, e legendas ASS ou PGS costumam forçar a conversão do vídeo. Nesses casos o Jellyfin transcodifica. Se ficar lento, o próximo passo é a transcodificação por hardware (Intel QSV/VAAPI).
