#!/usr/bin/env bash
set -e
echo -e "--- start done.sh ---\n\n"

umount -v $LFS/dev/pts
umount -v $LFS/dev
umount -v $LFS/run
umount -v $LFS/proc
umount -v $LFS/sys

echo -e "--- done done.sh ---\n\n"