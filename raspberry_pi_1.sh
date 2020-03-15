#!/bin/bash

################################################################################
# SETUP SCRIPT FOR RASPBERRY PI 1
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
#packages
################################################################################
#pivpn
curl -L https://install.pivpn.io | bash
################################################################################
#dotfiles
################################################################################
mkdir /home/pi/configs
#nano
ln -sf $(DIR)/nanorc /etc/nanorc
#motd
sudo rm /etc/update-motd.d
sudo ln -s $(DIR)/update-motd.d /etc/update-motd.d
sudo chmod -R 777 /etc/update-motd.d
#homeassistant

git clone https://github.com/DanielSima/home-assistant.git /home/win/configs/homeassistant
#git clone https://github.com/DanielSima/home-assistant.git /home/win/configs/organizr
#git clone https://github.com/DanielSima/home-assistant.git /home/win/configs/pihole







#git clone --single-branch --branch testbranch  https://github.com/DanielSima/test.git /home/win/configs/tes2
################################################################################
#containers
################################################################################
#homeassistant
docker run --init -d --restart=unless-stopped --name homeassistant -e TZ=Europe/Prague \
-v /home/pi/configs/home-assistant:/config --net=host \
homeassistant/raspberrypi3-homeassistant:stable

#pihole
docker run --init -d --restart=unless-stopped --name pihole -e TZ=Europe/Prague \
-v /home/pi/configs/pihole/pihole/:/etc/pihole -v /home/pi/configs/pihole/dnsmasq.d/:/etc/dnsmasq.d \
-p 53:53/tcp -p 53:53/udp -p 80:80 -p 443:443 --dns=127.0.0.1 --dns=8.8.8.8 \
pihole/pihole:latest

#organizr
docker run --init -d --restart unless-stopped --name organizr -e TZ=Europe/Prague \
-v /home/pi/configs/organizr:/config \
-e PUID=1000 -e PGID=1000 -p 9983:80 \
linuxserver/organizr