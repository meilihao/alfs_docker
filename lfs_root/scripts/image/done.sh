#!/usr/bin/env bash
set -e
echo -e "--- start done.sh ---\n\n"

umount -v $LFS/dev/pts || true
umount -v $LFS/dev     || true
umount -v $LFS/run     || true
umount -v $LFS/proc    || true
umount -v $LFS/sys     || true

mountpoint -q $LFS/boot/efi && umount $LFS/boot/efi
mountpoint -q $LFS/boot && umount $LFS/boot
mountpoint -q $LFS && umount $LFS

echo -e "--- done done.sh ---\n\n"