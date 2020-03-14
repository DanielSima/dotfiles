#!/bin/bash

################################################################################
# SETUP SCRIPT FOR DEBIAN
################################################################################

#BEFORE THIS DO MANUALLY:

#ssh-keygen -R "192.168.."
#ssh pi@192.168..
#passwd
#sudo passwd
#sudo apt-get update && sudo apt-get upgrade
#sudo apt install git
#mkdir /home/pi/configs
#git clone https://github.com/DanielSima/home-assistant.git /home/win/configs/debian
#/home/win/configs/debian/debian.sh

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
#apps
sudo apt-get install -y samba iotop iftop htop smartmontools nano neofetch
#docker
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
sudo curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add
sudo add-apt-repository "deb https://download.docker.com/linux/debian buster stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker

################################################################################
#dotfiles
################################################################################
#nano
ln -sf $(DIR)/nanorc /etc/nanorc
#motd
sudo rm /etc/update-motd.d
sudo ln -s $(DIR)/update-motd.d /etc/update-motd.d
sudo chmod -R 777 /etc/update-motd.d
