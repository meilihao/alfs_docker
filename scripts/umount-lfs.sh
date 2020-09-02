#!/usr/bin/env bash
set -e

echo -e "--- start umount-lfs.sh ---\n\n"

mountpoint -q $LFS/boot/efi && umount $LFS/boot/efi
mountpoint -q $LFS/boot && umount $LFS/boot
mountpoint -q $LFS && umount $LFS

echo -e "--- done umount-lfs.sh ---\n\n"