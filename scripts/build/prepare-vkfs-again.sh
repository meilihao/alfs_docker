#!/usr/bin/env bash
set -e
echo -e "--- start prepare-vkfs-again.sh ---\n\n"

echo "Preparing Virtual Kernel File Systems again .."

mount -v --bind /dev $LFS/dev

mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

echo -e "--- done prepare-vkfs-again.sh ---\n\n"