#!/usr/bin/env bash
set -e
echo -e "--- start run-build.sh ---\n\n"

${LFSRoot}/scripts/build/prepare-vkfs.sh

chroot "$LFS" /usr/bin/env -i   \
    LFSVersion="$LFSVersion"    \
    LFSRoot="$LFSRootInChroot"  \
    MAKEFLAGS="$MAKEFLAGS"      \
    LFS_DOCS="$LFS_DOCS"        \
    LFS_TEST="$LFS_TEST"        \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h \
    -c "${LFSRootInChroot}/scripts/build/run-build-in-chroot.sh"

umount $LFS/dev{/pts,}
umount $LFS/{sys,proc,run}

# 7.14.1. Stripping
# strip --strip-debug $LFS/usr/lib/*
# strip --strip-unneeded $LFS/usr/{,s}bin/*
# strip --strip-unneeded $LFS/tools/bin/*

if $BackupBeforRealInstall; then
    pushd $LFS && \
    if [ -f ${LFSRoot}/iso/lfs-temp-tools-${LFSVersion}.tar.gz ]; then
        mv -v ${LFSRoot}/iso/lfs-temp-tools-${LFSVersion}.tar.gz ${LFSRoot}/iso/lfs-temp-tools-${LFSVersion}-`date +%s`.tar.gz
    fi         && \
    tar --exclude=lfs_root -czpf ${LFSRoot}/iso/lfs-temp-tools-${LFSVersion}.tar.gz . && \
    popd
fi

# restore.sh is not in chroot

${LFSRoot}/scripts/build/prepare-vkfs-again.sh

chroot "$LFS" /usr/bin/env -i   \
    LFSVersion="$LFSVersion"    \
    LFSRoot="$LFSRootInChroot"  \
    MAKEFLAGS="$MAKEFLAGS"      \
    LFS_DOCS="$LFS_DOCS"        \
    LFS_TEST="$LFS_TEST"        \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h \
    -c "${LFSRootInChroot}/scripts/build/run-build-in-chroot-again.sh"

chroot "$LFS" /usr/bin/env -i          \
    LFSVersion="$LFSVersion"           \
    HOME=/root TERM="$TERM"            \
    LFS_DOCS="$LFS_DOCS"               \
    LFS_TEST="$LFS_TEST"               \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login \
    -c "${LFSRootInChroot}/scripts/build/cleanup3.sh"

chroot "$LFS" /usr/bin/env -i          \
    LFSVersion="$LFSVersion"           \
    LFSRoot="$LFSRootInChroot"         \
    MAKEFLAGS="$MAKEFLAGS"             \
    LFS_DOCS="$LFS_DOCS"               \
    LFS_TEST="$LFS_TEST"               \
    HOME=/root TERM="$TERM"            \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login \
    -c "${LFSRootInChroot}/scripts/build/run-build-in-chroot-system-config.sh"

${LFSRoot}/scripts/build/done.sh

echo -e "--- done run-build.sh ---\n\n"
