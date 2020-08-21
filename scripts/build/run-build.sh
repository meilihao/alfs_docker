#!/usr/bin/env bash
set -e
echo -e "--- start run-build.sh ---\n\n"

LFS_Script_Build=${LFSRoot}/scripts/build

${LFS_Script_Build}/prepare-vkfs.sh

chroot "$LFS" /usr/bin/env -i   \
    LFSRoot=/lfs_root           \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h \
    -c "/lfs_root/scripts/build/run-build-in-chroot.sh"

unset LFS_Script_Build

echo -e "--- done run-build.sh ---\n\n"
