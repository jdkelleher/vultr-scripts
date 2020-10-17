#!/bin/sh


# Note: Don't do anythnig in here that should really be handled by a config management system, e.g. install non-foundational packages, ccreate users, etc.


# Set some variables to be used later in the script

SSH_PORT=22	# Set this to something other than the standard ssh port



# First, make sure snap doesn't do anythnig silly

apt-get purge snapd


# Install sshguard !!!!

apt-get install sshguard


# Move ssh to different port, just because it's easy to do and means less work for sshguard

cat <<- EOInp > /etc/ssh/sshd_config.d/set_port.conf
	Port ${SSH_PORT}
EOInp


# Use a vi-style command line editing for root sessions

cat <<- EOInp >> /root/.bashrc

	# set vi-style command line editingvi-style command line editing
	set -o vi
EOInp


# Make sure vim is installed and the default editor

apt-get -y install vim
update-alternatives --set editor /usr/bin/vim.basic



# Create a swapfile - https://www.vultr.com/docs/setup-swap-file-on-linux

dd if=/dev/zero of=/swapfile count=2048 bs=1M
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
cat <<- EOInp >> /etc/fstab
	# swap file for paging
	/swapfile	none	swap	sw	0	0
EOInp


# update all packages

apt-get update 
apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade
apt-get clean
apt-get -y autoremove


# Reboot to make sure everything is as it should be

init 6

