# Raspberry Pi 2
These are dotfiles for the debian distribution. The script likely works on other distributions too but it's untested.

Originally intended to setup Raspberry Pis after first boot up.

## Usage

set passwords for user and root:

	passwd
	sudo passwd

update system:

	sudo apt-get update && sudo apt-get upgrade
    
download git:

	sudo apt install git
    
create dotfiles folder:

	mkdir /home/[USER]/dotfiles
    
download this branch:

	git clone --single-branch --branch debian https://github.com/DanielSima/dotfiles.git /home/[USER]/dotfiles/debian

give execute permission:

	sudo chmod +r /home/[USER]/dotfiles/debian/debian.sh

and finally execute the script:

	/home/[USER]/dotfiles/debian/debian.sh
    
### Note
If connecting through SSH use `ssh-keygen -R "[ip]"` to delete previous SSH key.