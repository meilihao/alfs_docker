#!/usr/bin/env bash
set -e
echo "--- start run-build.sh ---"

LFS_Script_Build=/lfs/scripts/build

#${LFS_Script_Build}/prepare-vkfs.sh

mkdir -pv $LFS/lfs/scripts/build
cp -r /lfs/scripts/build/inchroot/* $LFS/lfs/scripts/build

chroot "$LFS" /usr/bin/env -i   \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h \
    -c "/lfs/scripts/build/run-build.sh"

unset LFS_Script_Build

echo -e "--- done run-build.sh ---\n\n"
