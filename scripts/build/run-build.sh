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

# 7.14.1. Stripping
strip --strip-debug $LFS/usr/lib/*        || true
strip --strip-unneeded $LFS/usr/{,s}bin/* || true
strip --strip-unneeded $LFS/tools/bin/*   || true

if $BackupBeforRealInstall; then
    umount $LFS/dev{/pts,}
    umount $LFS/{sys,proc,run}

    pushd $LFS && \
    if [ -f /mnt/lfs-temp-tools-${LFSVersion}.tar.gz ]; then
        mv -v /mnt/lfs-temp-tools-${LFSVersion}.tar.gz /mnt/lfs-temp-tools-${LFSVersion}-`date +%s`.tar.gz
    fi         && \
    tar --exclude=lfs_root -czpf /mnt/lfs-temp-tools-${LFSVersion}.tar.gz . && \
    popd

    # restore.sh is not in chroot
    ${LFSRoot}/scripts/build/prepare-vkfs-again.sh
fi

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
    LFSRoot="$LFSRootInChroot"         \
    MAKEFLAGS="$MAKEFLAGS"             \
    LFS_DOCS="$LFS_DOCS"               \
    LFS_TEST="$LFS_TEST"               \
    HOME=/root TERM="$TERM"            \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login \
    -c "${LFSRootInChroot}/scripts/build/run-build-in-chroot-system-config.sh"

echo -e "--- done run-build.sh ---\n\n"
