#!/bin/sh

# This script is run by debian installer using preseed/late_command
# directive, see preseed.cfg

USER=vagrant
SSH_DIR=/home/${USER}/.ssh
SSH_KEY=${SSH_DIR}/authorized_keys
SUDO_FILE=/etc/sudoers.d/${USER}

# sudo file
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' > ${SUDO_FILE}
chmod 440 ${SUDO_FILE}

# ssh dir
mkdir -p ${SSH_DIR}
chmod 700 ${SSH_DIR}

# setup ssh key
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O ${SSH_KEY}
chmod 600 ${SSH_KEY}
chown -R ${USER} ${SSH_DIR}

# Configure ifplugd to monitor the eth0 interface.
sed -i -e 's/INTERFACES=.*/INTERFACES="eth0"/g' /etc/default/ifplugd

# Ensure the networking interfaces get configured on boot.
systemctl enable systemd-networkd.service

# Ensure ifplugd also gets started, so the ethernet interface is monitored.
systemctl enable ifplugd.service
