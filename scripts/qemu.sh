#!/usr/bin/env bash
set -e

echo -e "--- start qemu.sh ---\n\n"

# qemu-img create -f <fmt> <image filename> <size of disk>
qemu-img create -f qcow2 lfs.img 8G

sudo modprobe -v nbd

sudo qemu-nbd -c /dev/nbd0 lfs.img


# see result
sudo  gdisk -l /dev/nbd0

qemu-nbd --disconnect /dev/nbd0

echo -e "--- done qemu.sh ---\n\n"