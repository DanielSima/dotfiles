#!/bin/bash

################################################################################
# SETUP SCRIPT FOR RASPBERRY PI 1
################################################################################

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
pivpn add #xx.duckdns.org
################################################################################
#containers
################################################################################
#homeassistant
sudo docker run --init -d --restart=unless-stopped --name homeassistant -e TZ=Europe/Prague \
-v /home/pi/dotfiles/raspberry_pi_1/homeassistant:/config --net=host \
homeassistant/raspberrypi3-homeassistant:stable

#pihole
sudo docker run -d --restart=unless-stopped --name pihole -e TZ=Europe/Prague \
-v /home/pi/dotfiles/raspberry_pi_1/pihole/pihole:/etc/pihole -v /home/pi/dotfiles/raspberry_pi_1/pihole/dnsmasq.d/:/etc/dnsmasq.d \
--net=host --cap-add=NET_ADMIN --dns=127.0.0.1 --dns=8.8.8.8 -e ServerIP="192.168.0.151" \
pihole/pihole:latest
################################################################################
#config
################################################################################
sudo nano /etc/hostname
sudo nano /etc/hosts
sudo reboot now