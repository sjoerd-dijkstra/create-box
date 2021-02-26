#!/usr/bin/env bash

DISK="/var/lib/libvirt/images/${1}.img"

qemu-img create -f qcow2 -o preallocation=metadata "${DISK}" 128G

sudo virt-install \
 --name "${1}" \
 --ram 16384 \
 --machine q35 \
 --cpu host-passthrough,cache.mode=passthrough \
 --features kvm_hidden=on \
 --disk path="${DISK}",bus=virtio,cache=none \
 --initrd-inject preseed.cfg \
 --initrd-inject postinst.sh \
 --vcpus 10,sockets=1,cores=5,threads=2 \
 --cpuset 1-5,7-11 \
 --host-device 07:00.0 \
 --host-device 07:00.1 \
 --network network=default,address.type=pci,address.bus=6 \
 --os-type linux \
 --os-variant ubuntu20.04 \
 --location http://ftp.ubuntu.com/ubuntu/dists/focal/main/installer-amd64 \
 --graphics none \
 --boot uefi \
 --extra-args "auto=true hostname=${1} domain=${DOMAIN} console=tty0 console=ttyS0,115200n8 serial"
#  --noautoconsole \
