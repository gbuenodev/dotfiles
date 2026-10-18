# hyrule

Servidor doméstico, NixOS em `x86_64-linux`. O nome vem do primeiro mundo que o Link explora.

- Sistema: `hosts/hyrule/default.nix`; serviços: um arquivo por serviço em `hosts/hyrule/`
- Acesso: `ssh hyrule` (`hyrule.local`, IP fixo `192.168.0.14`)
- Repo clonado em `~/dotfiles`, por HTTPS e só para leitura

## Hardware

| | |
|---|---|
| CPU | Intel, 8 núcleos |
| RAM | 15 GiB |
| Disco | NVMe ADATA 512 GB (`nvme0n1`) |
| Rede | Wi-Fi `wlp0s20f3` |
| Firmware | UEFI |

É um notebook usado como servidor; pode ficar com a tampa fechada.

## Disco

| Partição | Tamanho | Formato | Rótulo | Montagem |
|---|---|---|---|---|
| `nvme0n1p1` (ESP) | 1 GB | vfat | `BOOT` | `/boot` (`umask=077`) |
| `nvme0n1p2` | o resto | btrfs | `nixos` | subvolumes abaixo |

| Subvolume | Montagem |
|---|---|
| `@` | `/` |
| `@home` | `/home` |
| `@nix` | `/nix` |

- Os três são montados com `compress=zstd,noatime`. Essas opções ficam no `default.nix`, porque o `hardware-configuration.nix` gerado só tem o `subvol=`.
- Não há partição de swap: o `zramSwap` cria um swap comprimido em RAM, de até 50% dela.

## Sistema

- **Boot:** systemd-boot.
- **Nunca suspende:** o logind ignora a tampa (`HandleLidSwitch`, `...ExternalPower` e `...Docked` = `ignore`), e os alvos `sleep`, `suspend`, `hibernate` e `hybrid-sleep` estão mascarados. O `nixos-rebuild switch` não reinicia o logind; mudanças nele só valem depois de reiniciar a máquina.
- **Rede:** NetworkManager e Avahi, que publica `hyrule.local`.
- **Acesso:** OpenSSH só por chave (a `~/.ssh/id_ed25519.pub` do kokiri), sem senha e sem root.
- **Usuário:** `gbueno`, nos grupos `wheel` e `networkmanager`, com zsh e o mesmo [ambiente](home.md) do Mac.
- **Pacotes:** git, neovim, rsync (recebe o `mediasync`) e a terminfo do Ghostty. Sem ela, o `less` e outros programas falham por SSH com `'xterm-ghostty': unknown terminal type`.
- **Nixpkgs:** o mesmo `nixpkgs-unstable` do Mac. Instalado com o ISO 26.05, por isso o `system.stateVersion = "26.05"`.

## Serviços

| Serviço | Arquivo | Endereço |
|---|---|---|
| Jellyfin | `hosts/hyrule/jellyfin.nix` | `http://hyrule.local:8096` |

Ver [Mídia](media.md).

## Mudanças

Edite no kokiri, faça o commit e o push. Depois, no hyrule:

```sh
git -C ~/dotfiles pull && nxr
```

Para testar sem ativar, rode `nixos-rebuild build --flake ~/dotfiles#hyrule`, que não precisa de `sudo`.

## Fora do repo

| O quê | Onde | Como foi feito |
|---|---|---|
| Wi-Fi (senha) e IP fixo | `/etc/NetworkManager/system-connections/` (root, 600) | arquivo `.nmconnection` copiado do ISO; IP com `nmcli con mod G2 ipv4.method manual ipv4.addresses 192.168.0.14/24 ipv4.gateway 192.168.0.1 ipv4.dns 192.168.0.1` |
| Senha do `gbueno` | `/etc/shadow` | `nixos-enter --root /mnt -c 'passwd gbueno'` na instalação |
| Root | bloqueado | `nixos-install --no-root-passwd` |
| Dados do Jellyfin | `/var/lib/jellyfin` | assistente web |

## Reinstalar

1. Dar boot pelo ISO minimal do NixOS (UEFI, Secure Boot desligado). Conectar na Wi-Fi com `nmcli --ask device wifi connect "<rede>"`, rodar `passwd` e entrar por SSH com `ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null nixos@<ip>`.
2. Particionar:

   ```sh
   sudo wipefs -a /dev/nvme0n1
   sudo parted /dev/nvme0n1 -- mklabel gpt
   sudo parted /dev/nvme0n1 -- mkpart ESP fat32 1MB 1GB
   sudo parted /dev/nvme0n1 -- set 1 esp on
   sudo parted /dev/nvme0n1 -- mkpart root ext4 1GB 100%
   ```

3. Formatar, criar os subvolumes e montar:

   ```sh
   sudo mkfs.fat -F 32 -n BOOT /dev/nvme0n1p1
   sudo mkfs.btrfs -f -L nixos /dev/nvme0n1p2
   sudo mount /dev/disk/by-label/nixos /mnt
   for s in @ @home @nix; do sudo btrfs subvolume create /mnt/$s; done
   sudo umount /mnt
   opts=compress=zstd,noatime
   sudo mount -o subvol=@,$opts /dev/disk/by-label/nixos /mnt
   sudo mkdir -p /mnt/{home,nix,boot}
   sudo mount -o subvol=@home,$opts /dev/disk/by-label/nixos /mnt/home
   sudo mount -o subvol=@nix,$opts /dev/disk/by-label/nixos /mnt/nix
   sudo mount -o umask=077 /dev/disk/by-label/BOOT /mnt/boot
   ```

4. Gerar a config do hardware e trocá-la pela do repo. Os UUIDs mudam a cada formatação:

   ```sh
   sudo nixos-generate-config --root /mnt
   nix-shell -p git --run 'git clone https://github.com/gbuenodev/dotfiles.git /tmp/dotfiles'
   cp /mnt/etc/nixos/hardware-configuration.nix /tmp/dotfiles/hosts/hyrule/
   ```

5. Copiar a conexão Wi-Fi para o disco:

   ```sh
   sudo mkdir -p /mnt/etc/NetworkManager/system-connections
   sudo cp -a /etc/NetworkManager/system-connections/*.nmconnection /mnt/etc/NetworkManager/system-connections/
   ```

6. Instalar pelo clone e definir a senha: `sudo nixos-install --no-root-passwd --flake /tmp/dotfiles#hyrule`, depois `sudo nixos-enter --root /mnt -c 'passwd gbueno'`.
7. Reiniciar, clonar o repo em `~/dotfiles`, refazer o IP fixo com o `nmcli` (ver acima) e mandar o `hardware-configuration.nix` novo para o repo, pelo kokiri.
