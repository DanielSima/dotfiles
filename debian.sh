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
#git clone  --single-branch --branch debian https://github.com/DanielSima/dotfiles.git /home/pi/configs/debian
#sudo chmod 777 /home/pi/configs/debian/debian.sh
#/home/pi/configs/debian/debian.sh

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
#config
################################################################################
sudo timedatectl set-timezone Europe/Prague
################################################################################
#packages
################################################################################
sudo apt-get install -y samba iotop iftop htop smartmontools nano neofetch
#docker
curl https://get.docker.com | sh
sudo usermod -aG docker pi
#glances
curl -L https://bit.ly/glances | /bin/bash
################################################################################
#dotfiles
################################################################################
#nano
sudo ln -sf $(DIR)/nanorc /etc/nanorc
#glances
sudo mkdir -p /etc/glances
sudo ln -sf $(DIR)/glances/glances.conf /etc/glances/glances.conf
sudo ln -sf $(DIR)/glances/glances.service /etc/systemd/system/glances.service
sudo systemctl enable glances
sudo systemctl start glances
#motd
sudo rm /etc/motd
sudo rm -r /etc/update-motd.d
sudo ln -s $(DIR)/update-motd.d /etc/update-motd.d
sudo chmod -R 777 /etc/update-motd.d
#bash
ln -sf $(DIR)/.bash_functions /home/pi/.bash_functions
ln -sf $(DIR)/.bashrc /home/pi/.bashrc
#samba
sudo ln -sf $(DIR)/smb.conf /etc/samba/smb.conf
sudo systemctl restart smbd