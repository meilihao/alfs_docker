#!/usr/bin/env bash
set -e
echo -e "--- start done.sh in chroot ---\n\n"

umount -v $LFS/dev/pts
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys

umount -v $LFS

echo -e "--- done done.sh in chroot ---\n\n"