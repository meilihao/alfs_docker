#!/usr/bin/env bash
set -e
echo -e "--- start done.sh ---\n\n"

umount -v $LFS/dev/pts
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys

mountpoint -q $LFS/boot/efi && umount $LFS/boot/efi
mountpoint -q $LFS/boot && umount $LFS/boot
mountpoint -q $LFS && umount $LFS

echo -e "--- done done.sh ---\n\n"