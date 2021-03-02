#!/usr/bin/env bash

DISK=/var/lib/libvirt/images/vagrant.img

qemu-img create -f qcow2 -o preallocation=metadata "${DISK}" 128G

virt-install \
 --name vagrant \
 --ram 16384 \
 --machine q35 \
 --vcpus 8 \
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
