#!/bin/bash

################################################################################
# SETUP SCRIPT FOR DEBIAN
################################################################################

# exit when any command fails
set -e
# keep track of the last executed command
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
# echo an error message before exiting
trap 'echo "\"${last_command}\" command failed with exit code $?."' EXIT
#save current dir, the cloned repo location
DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
#save the user, works even when using sudo
USER="$(who am i | awk '{print $1}')"
################################################################################
#config
################################################################################
sudo timedatectl set-timezone Europe/Prague
#git
git config --global user.email "dan0nik192000@gmail.com"
git config --global user.name "DanielSima"
################################################################################
#packages
################################################################################
sudo apt-get install -y samba iotop iftop htop smartmontools nano neofetch
#docker
curl https://get.docker.com | sh
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
sudo chmod +r /etc/update-motd.d
#bash
sudo ln -sf $(DIR)/bash/.bash_functions /home/$(USER)/.bash_functions
sudo ln -sf $(DIR)/bash/.bash_aliases/home/$(USER)/.bash_aliases
sudo ln -sf $(DIR)/bash/.bashrc /home/$(USER)/.bashrc
#samba
sudo ln -sf $(DIR)/smb.conf /etc/samba/smb.conf
sudo systemctl restart smbd