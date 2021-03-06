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

# networking: automatically get ips with new nics, based on mac
cat <<-EOF > /etc/netplan/01-netcfg.yaml
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
      dhcp-identifier: mac
EOF

# Apply the network plan configuration.
netplan generate

# setup the hardware dhcp
sed -i 's/^#*\(send dhcp-client-identifier\).*$/\1 = hardware;/' /etc/dhcp/dhclient.conf

# update grub to see eth0 interfaces
sed -ie 's/GRUB_CMDLINE_LINUX=.*/GRUB_CMDLINE_LINUX="net.ifnames=0 ipv6.disable=1 biosdevname=0"/' /etc/default/grub
update-grub2
