#!/usr/bin/env bash

set -e

[[ -n ${DEBUG_SCRIPT} ]] && set -x

NAME=vagrant-auto-install
DISK=/var/lib/libvirt/images/${NAME}.img

# create image disk file
qemu-img create -f qcow2 -o preallocation=metadata "${DISK}" 128G

# install the os
virt-install \
 --name ${NAME} \
 --ram 16384 \
 --vcpus 8 \
 --machine q35 \
 --boot uefi \
 --noautoconsole \
 --disk path="${DISK}",bus=virtio,cache=none \
 --initrd-inject preseed.cfg \
 --initrd-inject postinst.sh \
 --os-type linux \
 --os-variant ubuntu20.04 \
 --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64 \
 --graphics none \
 --extra-args "auto=true hostname=vagrant domain=${DOMAIN} console=tty0 console=ttyS0,115200n8 serial"

# wait till installation finished
while [ "$(virsh list | grep -c ${NAME})" != "0" ]
do
  sleep 5
done

# create the box
qemu-img convert -m 12 -p -c -O qcow2 ${DISK} box.img
tar cf - box.img metadata.json Vagrantfile | pigz > ${NAME}.box
chmod 644 vagrant.box

# clean up
virsh undefine --nvram ${NAME}
rm box.img ${DISK}
