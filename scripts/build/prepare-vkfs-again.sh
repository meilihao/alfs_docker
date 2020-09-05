#!/usr/bin/env bash
set -e
echo -e "--- start prepare-vkfs-again.sh ---\n\n"

echo "Preparing Virtual Kernel File Systems again .."

mount -v --bind /dev $LFS/dev

mount -v --bind /dev/pts $LFS/dev/pts
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

# return !0 when not mount
# glibc test need /dev/fd/xxx
if [ `mountpoint -q $LFS/dev` ]; then
    echo "****** not mount $LFS/dev"
    exit 1
fi

echo -e "--- done prepare-vkfs-again.sh ---\n\n"