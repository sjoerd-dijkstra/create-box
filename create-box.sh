#!/usr/bin/env bash

sudo cp "/var/lib/libvirt/images/${1}.img" box.img
sudo virt-sparsify --in-place box.img
sudo tar cf - box.img metadata.json Vagrantfile | pigz > "${1}.box"
sudo chmod 644 "${1}.box"
rm box.img
