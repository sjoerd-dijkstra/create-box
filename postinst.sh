#!/bin/sh

# This script is run by debian installer using preseed/late_command
# directive, see preseed.cfg

USER=vagrant
SSH_DIR=/home/${USER}/.ssh
SSH_KEY=${SSH_DIR}/authorized_keys
SUDO_FILE=/etc/sudoers.d/${USER}

# sudo file
echo 'vagrant ALL=(ALL) NOPASSWD:ALL' > ${SUDO_FILE}
echo "Defaults:${USER} !requiretty" >> ${SUDO_FILE}
chmod 440 ${SUDO_FILE}

# ssh dir
mkdir -p ${SSH_DIR}
chmod 700 ${SSH_DIR}

# setup ssh key
wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O ${SSH_KEY}
chmod 600 ${SSH_KEY}
chown -R ${USER} ${SSH_DIR}

cat <<-EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
      dhcp-identifier: mac
EOF

sed -i 's/^#*\(send dhcp-client-identifier\).*$/\1 = hardware;/' /etc/dhcp/dhclient.conf
sed -ie 's/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="net.ifnames=0 ipv6.disable=1 biosdevname=0"/' /etc/default/grub

update-grub2

# Configure ifplugd to monitor the eth0 interface.
sed -i -e 's/INTERFACES=.*/INTERFACES="eth0"/g' /etc/default/ifplugd

# Ensure the networking interfaces get configured on boot.
systemctl enable systemd-networkd.service

# Ensure ifplugd also gets started, so the ethernet interface is monitored.
systemctl enable ifplugd.service
