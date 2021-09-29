# Dotfiles - Configs

## Bash

- **Dependencies:**

    None

- **Prerequisites:**

    None

- **What Does it Do:**

    Replaces `~/.bashrc`, `~/.bash_profile`, `~/.bash_aliases` and `~/.bash_functions`.

## Borg Backup

- **Dependencies:**

    BorgBackup

    systemd

    sudo

- **Prerequisites:**

    Initialize Borg repository.

    Create a file `/secrets/borg` containing Borg repository's passphrase.

    Create a file `/secrets/discord` containing the URL of your Discord server webhook.

- **What Does it Do:**

    Creates a service and timer that runs the backup on a regular basis.

    Compresses, deduplicates, encrypts, and backs up data to an ssh accessible location.

    Prunes old backups.

    On error, sends a message to your Discord server.

## DuckDNS

- **Dependencies:**

    Docker

    sudo

- **Prerequisites:**

    Create a file `/secrets/duck_subdomains` containing your DuckDNS subdomain.

    Create a file `/secrets/duck_token` containing your DuckDNS token.

- **What Does it Do:**

    Starts a docker container that sends your public IP address to DuckDNS.

    You can then access your home network (over VPN preferably) from anywhere using the DuckDNS domain.

    This is useful when your ISP does not give static IPs.

## Git

- **Dependencies:**

    Git

- **Prerequisites:**

    None

- **What Does it Do:**

    Replaces `~/.gitconfig`.

## Glances

- **Dependencies:**

    systemd

    sudo

- **Prerequisites:**

    None

- **What Does it Do:**

    Installs Glances if not installed.

    Creates a service that starts the Glances Web interface.

    Glances is a system monitoring tool similar to htop.

## Home Assistant

- **Dependencies:**

    Docker

    sudo

- **Prerequisites:**

    TODO

- **What Does it Do:**

    Starts a docker container.

    Home Assistant is a home automation program.

## Media Center

- **Dependencies:**

    sudo

- **Prerequisites:**

    None

- **What Does it Do:**

    Installs Docker if not installed.

    Starts containers:

    - qBittorrent - BitTorrent client
    - Plex - Client–server media player
    - Tautulli - Plex monitoring tool
    - Jackett - Proxy server for torrents
    - Sonarr - Automatic TV downloader
    - Radarr - Automatic movie downloader

## Monitor Reset

- **Dependencies:**

    xrandr

    systemd

    sudo

- **Prerequisites:**

    None

- **What Does it Do:**

    Creates a service which runs xrandr to detect monitors after hibernation.

    TODO still occasionally doesn't work.

## Pi-hole

- **Dependencies:**

    Docker

    sudo

- **Prerequisites:**

    Make sure the device you run this on has static IP address.

    Modify [pihole.yaml](./pihole.yaml) with the correct ServerIP variable.

    After executing the config, open the web GUI and import [pihole-backup](../../tools/pihole/pihole-backup). (Most likely first tar the folder.)

    Modify your router so the default and only DNS server is ServerIP.

- **What Does it Do:**

    Starts a docker container that runs Pi-hole, a DNS sinkhole.

    It is used to block ads and trackers network wide, including devices which don't have regular ad blocks like TVs and consoles.

## Rofi

- **Dependencies:**

    Rofi

    Spectacle

    NormCap

    Xdotool

- **Prerequisites:**

    none

- **What Does it Do:**

    Replaces `~/.config/rofi/config.rasi`.

    Rofi is a window switcher and an application launcher. Similiar to dmenu or the Start menu on Windows.

    It is the first step of moving from KDE to more customizable and easier to source control tools. Right now, it probably doesn't make much sense on it's own.
