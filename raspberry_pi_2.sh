#!/bin/bash

################################################################################
# SETUP SCRIPT FOR RASPBERRY PI 2
################################################################################

# exit when any command fails
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command failed with exit code $?."' EXIT
#save current dir, the cloned repo location
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

################################################################################
#containers
################################################################################
#qbittorrent
sudo docker run -d --restart unless-stopped --name=qbittorrent -e TZ=Europe/Prague \
-v /home/pi/dotfiles/raspberry_pi_2/qbittorrent:/config -v /media/disk1/unorganized:/downloads \
-e PUID=1000 -e PGID=1000 -e UMASK_SET=022 -e WEBUI_PORT=8080 -p 6881:6881 -p 6881:6881/udp -p 8080:8080 \
linuxserver/qbittorrent

#plex
sudo docker run -d --restart unless-stopped --name=plex -e TZ=Europe/Prague \
-v /home/pi/dotfiles/raspberry_pi_2/plex:/config -v /media/disk1/tvshows:/tv -v /media/disk1/movies:/movies -v /media/disk1/transcoder:/transcode \
--net=host -e PUID=1000 -e PGID=1000 -e VERSION=docker -e UMASK_SET=022  \
linuxserver/plex

#jackett
sudo docker run -d --restart unless-stopped --name=jackett -e TZ=Europe/Prague \
-v /home/pi/dotfiles/raspberry_pi_2/jackett:/config -v /media/disk1/torrents:/downloads \
-e PUID=1000 -e PGID=1000  -p 9117:9117 \
linuxserver/jackett

#the next containers are using mount to just /media/disk1. the /tv, /movies and /downloads mount are then setuped manully.
#this is so we are using just one mount and hardlinks can work.
#sonarr
sudo docker run -d --restart unless-stopped --name=sonarr -e TZ=Europe/Prague \
-v /home/pi/dotfiles/raspberry_pi_2/sonarr:/config -v /media/disk1:/tv -v /media/disk1/notused:/downloads \
-e PUID=1000 -e PGID=1000 -e UMASK_SET=022 -p 8989:8989 \
linuxserver/sonarr

#radarr
sudo docker run -d --restart unless-stopped --name=radarr -e TZ=Europe/Prague \
-v /home/pi/dotfiles/raspberry_pi_2/radarr:/config -v /media/disk1:/movies -v /media/disk1/notused:/downloads \
-e PUID=1000 -e PGID=1000 -e UMASK_SET=022 -p 7878:7878 \
linuxserver/radarr
################################################################################
#dotfiles
################################################################################
#fan
sudo ln -sf $(DIR)/fan/fan.service /etc/systemd/system/fan.service
sudo systemctl enable fan
sudo systemctl start fan
#samba
sudo ln -sf $(DIR)/smb.conf /etc/samba/smb.conf
sudo systemctl restart smbd
################################################################################
#config
################################################################################
sudo nano /etc/hostname
sudo nano /etc/hosts
sudo reboot now