#!/usr/bin/env bash
set -e

## TODO : use python3 to do this by load a json config

echo -e "\n\n+++ start gdisk.sh for partition +++\n\n"

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | gdisk /dev/nbd0
  o # new gpt
  Y # Proceed
  n
  1

  +256M
  ef00 # EFI System
  n
  2

  +2048M
  8300
  n
  3
  
  
  
  w # write GPT data
  Y # want to proceed
EOF

gdisk -l /dev/nbd0

mkdir -pv $LFS
mkfs -F -v -t ext4 /dev/nbd0p3
mount -v -t ext4 /dev/nbd0p3 $LFS

mkdir -pv $LFS/boot
mkfs -F -v -t ext4 /dev/nbd0p2
mount -v -t ext4 /dev/nbd0p2 $LFS/boot

mkdir -pv $LFS/boot/efi
mkfs.fat -F 32 /dev/nbd0p1
mount -v -t vfat /dev/nbd0p1 $LFS/boot/efi

echo -e "+++ done gdisk.sh +++\n\n"