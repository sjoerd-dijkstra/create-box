#!/bin/sh

# This script is run by debian installer using preseed/late_command
# directive, see preseed.cfg

USER=vagrant
SSH_DIR=/home/${USER}/.ssh
SSH_KEY=${SSH_DIR}/authorized_keys
SSH_CONFIG=/etc/ssh/sshd_config
SUDO_FILE=/etc/sudoers.d/${USER}

# sudo file
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' > ${SUDO_FILE}
chmod 0440 ${SUDO_FILE}

# ssh dir
mkdir -p ${SSH_DIR}
chmod 0700 ${SSH_DIR}

# setup ssh key
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O ${SSH_KEY}
chmod 0600 ${SSH_KEY}
chown -R ${USER} ${SSH_DIR}

# change ssh config
sed -i 's/^.*PermitEmptyPasswords.*/PermitEmptyPasswords no/g' ${SSH_CONFIG}
sed -i 's/^.*PasswordAuthentication.*/PasswordAuthentication no/g' ${SSH_CONFIG}
