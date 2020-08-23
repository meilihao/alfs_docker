#!/usr/bin/env bash
set -e
echo -e "--- start run-build.sh ---\n\n"

${LFSRoot}/scripts/build/prepare-vkfs.sh

chroot "$LFS" /usr/bin/env -i   \
    LFSRoot=/lfs_root           \
    MAKEFLAGS="$MAKEFLAGS"      \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h \
    -c "${LFSRoot}/scripts/build/run-build-in-chroot.sh"

umount $LFS/dev{/pts,}
umount $LFS/{sys,proc,run}

# 7.14.1. Stripping
# strip --strip-debug $LFS/usr/lib/*
# strip --strip-unneeded $LFS/usr/{,s}bin/*
# strip --strip-unneeded $LFS/tools/bin/*

pushd $LFS && \
tar --exclude=lfs_root -czpf ${LFSRoot}/iso/lfs-temp-tools-10.0-systemd-`date +%s`.tar.gz . && \
popd

# restore.sh is not in chroot

${LFSRoot}/scripts/build/prepare-vkfs-again.sh

chroot "$LFS" /usr/bin/env -i   \
    LFSRoot=/lfs_root           \
    MAKEFLAGS="$MAKEFLAGS"      \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h \
    -c "${LFSRoot}/scripts/build/run-build-in-chroot-again.sh"

chroot "$LFS" /usr/bin/env -i          \
    HOME=/root TERM="$TERM"            \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login \
    - c "${LFSRoot}/scripts/build/cleanup3.sh"

chroot "$LFS" /usr/bin/env -i          \
    LFSRoot=/lfs_root                  \
    MAKEFLAGS="$MAKEFLAGS"             \
    HOME=/root TERM="$TERM"            \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login \
    - c "${LFSRoot}/scripts/build/run-build-in-chroot-system-config.sh"

echo -e "--- done run-build.sh ---\n\n"
