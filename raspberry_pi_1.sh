#!/bin/bash

################################################################################
# SETUP SCRIPT FOR RASPBERRY PI 1
################################################################################

#BEFORE THIS DO MANUALLY:

#git clone  --single-branch --branch raspberry_pi_1 https://github.com/DanielSima/dotfiles.git /home/pi/configs/raspberry_pi_1
#sudo chmod 777 /home/pi/configs/raspberry_pi_1/raspberry_pi_1.sh
#/home/pi/configs/raspberry_pi_1/raspberry_pi_1.sh

#SCRIPT START
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
#containers
################################################################################
#homeassistant
docker run --init -d --restart=unless-stopped --name homeassistant -e TZ=Europe/Prague \
-v /home/pi/configs/raspberry_pi_1/homeassistant:/config --net=host \
homeassistant/raspberrypi3-homeassistant:stable

#pihole
docker run --init -d --restart=unless-stopped --name pihole -e TZ=Europe/Prague \
-v /home/pi/configs/raspberry_pi_1/pihole/pihole:/etc/pihole -v /home/pi/configs/raspberry_pi_1/pihole/dnsmasq.d/:/etc/dnsmasq.d \
-p 53:53/tcp -p 53:53/udp -p 80:80 -p 443:443 --dns=127.0.0.1 --dns=8.8.8.8 \
pihole/pihole:latest

#organizr
docker run --init -d --restart unless-stopped --name organizr -e TZ=Europe/Prague \
-v /home/pi/configs/raspberry_pi_1/organizr:/config \
-e PUID=1000 -e PGID=1000 -p 9983:80 \
linuxserver/organizr