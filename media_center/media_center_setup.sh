#!/bin/bash

DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"

MEDIA_DIR="/media/disk1"

if ! command -v docker &> /dev/null
then
    echo 'Docker not found, installing:'
    curl https://get.docker.com | sh
fi

echo 'Setting up containers:'
#qbittorrent
sudo docker run -d --restart unless-stopped --name=qbittorrent -e TZ=Europe/Prague \
-v $(DIR)/qbittorrent:/config -v $(MEDIA_DIR)/unorganized:/downloads \
-e PUID=1000 -e PGID=1000 -e UMASK_SET=022 -e WEBUI_PORT=8080 -p 6881:6881 -p 6881:6881/udp -p 8080:8080 \
ghcr.io/linuxserver/qbittorrent

#plex
sudo docker run -d --restart unless-stopped --name=plex -e TZ=Europe/Prague \
-v $(DIR)/plex:/config -v $(MEDIA_DIR):/disk1 \
--net=host -e PUID=1000 -e PGID=1000 -e VERSION=docker -e UMASK_SET=022  \
ghcr.io/linuxserver/plex

#tautulli
sudo docker run -d --restart unless-stopped --name=tautulli -e TZ=Europe/Prague \
-v $(DIR)/tautulli:/config \
-e PUID=1000 -e PGID=1000 -e UMASK_SET=022 -p 8181:8181 \
ghcr.io/linuxserver/tautulli

#jackett
sudo docker run -d --restart unless-stopped --name=jackett -e TZ=Europe/Prague \
-v $(DIR)/jackett:/config -v $(MEDIA_DIR)/torrents:/downloads \
-e PUID=1000 -e PGID=1000  -p 9117:9117 \
ghcr.io/linuxserver/jackett

#sonarr
sudo docker run -d --restart unless-stopped --name=sonarr -e TZ=Europe/Prague \
-v $(DIR)/sonarr:/config -v $(MEDIA_DIR):/disk1 \
-e PUID=1000 -e PGID=1000 -e UMASK_SET=022 -p 8989:8989 \
ghcr.io/linuxserver/sonarr

#radarr
sudo docker run -d --restart unless-stopped --name=radarr -e TZ=Europe/Prague \
-v /$(DIR)/radarr:/config -v $(MEDIA_DIR):/disk1 \
-e PUID=1000 -e PGID=1000 -e UMASK_SET=022 -p 7878:7878 \
ghcr.io/linuxserver/radarr

echo 'Done.'
