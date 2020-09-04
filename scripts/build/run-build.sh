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
    if [ -f /mnt/lfs-backup-tools-${LFSVersion}.tar.xz ]; then
        mv -v /mnt/lfs-backup-tools-${LFSVersion}.tar.xz /mnt/lfs-backup-tools-${LFSVersion}-`date +%s`.tar.xz
    fi         && \
    tar --exclude=lfs_root -cJpf /mnt/lfs-backup-tools-${LFSVersion}.tar.xz . && \
    popd

    # restore.sh is not in chroot
    ${LFSRoot}/scripts/build/prepare-vkfs-again.sh
fi

${LFSRoot}/scripts/build/lfs.sh

echo -e "--- done run-build.sh ---\n\n"
