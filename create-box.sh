#!/usr/bin/env bash

qemu-img convert -c -O qcow2 /var/lib/libvirt/images/vagrant.img box.img
tar cf - box.img metadata.json Vagrantfile | pigz > vagrant.box
chmod 644 vagrant.box
