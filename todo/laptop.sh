#!/bin/bash

################################################################################
# SETUP SCRIPT FOR MY MAIN PC
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
#mouse https://wiki.archlinux.org/index.php/Bluetooth_mouse
sudo pacman -Syu
sudo pacman -S base-devel yay
yay -S google-chrome visual-studio-code-bin spotify qbittorrent
#KVM
yay -S ovmf libvirt qemu ebtables bridge-utils virt-manager
systemctl enable --now libvirtd
sudo gpasswd -a $USER libvirt
yay -S glances hddtemp python-matplotlib python-netifaces python-zeroconf
#mathematica
#https://user.wolfram.com/portal
yay -S mathematica
#next command before confirming read pkgbuild
 mv ~/Downloads/Mathematica_12.1.1_LINUX.sh /home/daniel/.cache/yay/mathematica/Mathematica_12.1.1_LINUX.sh
################################################################################
#dotfiles
################################################################################
#nano
sudo ln -sf $(DIR)/nanorc /etc/nanorc
#motd
sudo ln -sf $(DIR)/motd/motd /etc/motd
#bash
sudo ln -sf $(DIR)/bash/.bash_functions /home/$(USER)/.bash_functions
sudo ln -sf $(DIR)/bash/.bash_aliases/home/$(USER)/.bash_aliases
sudo ln -sf $(DIR)/bash/.bashrc /home/$(USER)/.bashrc
#VSCode
sudo ln -sf $(DIR)/VSCode/settings.json /home/$(USER)/.config/Code/User/settings.json
