#!/usr/bin/env bash
set -e

echo -e "+++ done mount_lfs.sh +++\n\n"

mkdir -pv $LFS
mkfs -F -v -t ext4 /dev/nbd0p3
mount -v -t ext4 /dev/nbd0p3 $LFS

mkdir -pv $LFS/boot
mkfs -F -v -t ext4 /dev/nbd0p2
mount -v -t ext4 /dev/nbd0p2 $LFS/boot

mkdir -pv $LFS/boot/efi
mkfs.fat -F 32 /dev/nbd0p1
mount -v -t vfat /dev/nbd0p1 $LFS/boot/efi

echo -e "+++ done mount_lfs.sh +++\n\n"