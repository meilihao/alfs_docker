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

umount $LFS/dev{/pts,}
umount $LFS/{sys,proc,run}

# 7.14.1. Stripping
# strip --strip-debug $LFS/usr/lib/*
# strip --strip-unneeded $LFS/usr/{,s}bin/*
# strip --strip-unneeded $LFS/tools/bin/*

# rm -rf $LFS/usr/share/{info,man,doc}

pushd $LFS && \
tar --exclude=lfs_root -czpf ${LFSRoot}/iso/lfs-temp-tools-10.0-systemd-rc1.tar.gz . && \
popd

${LFS_Script_Build}/prepare-vkfs-again.sh

chroot "$LFS" /usr/bin/env -i   \
    LFSRoot=/lfs_root           \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h \
    -c "/lfs_root/scripts/build/run-build-in-chroot-again.sh"

unset LFS_Script_Build

echo -e "--- done run-build.sh ---\n\n"
