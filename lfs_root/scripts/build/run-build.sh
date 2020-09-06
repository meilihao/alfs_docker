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
    if [ -f ${LFSRoot}/lfs-backup-tmpos-${LFSVersion}.tar.xz ]; then
        mv -v ${LFSRoot}/lfs-backup-tmpos-${LFSVersion}.tar.xz ${LFSRoot}/lfs-backup-tmpos-${LFSVersion}-`date +%s`.tar.xz
    fi         && \
    tar --exclude=lfs_root --exclude=logs -cJpf ${LFSRoot}/lfs-backup-tmpos-${LFSVersion}.tar.xz . && \
    popd

    ${LFSRoot}/scripts/build/prepare-vkfs-again.sh
fi

# for debug coreutils "FAIL tests/misc/chroot-credentials.sh (exit status: 1)"
cp -v /usr/bin/strace $LFS/bin
cp -v /lib/x86_64-linux-gnu/libunwind-ptrace.so.0 $LFS/lib/libunwind-ptrace.so.0
cp -v /lib/x86_64-linux-gnu/libunwind-x86_64.so.8 $LFS/lib/libunwind-x86_64.so.8
cp -v /lib/x86_64-linux-gnu/libunwind.so.8 $LFS/lib/libunwind.so.8

# for next 优化disk space
cp -v /usr/bin/ncdu $LFS/bin
cp -v /lib/x86_64-linux-gnu/libtinfo.so.6 $LFS/lib/libtinfo.so.6

${LFSRoot}/scripts/build/lfs.sh
${LFSRoot}/scripts/build/rootfs.sh

echo -e "--- done run-build.sh ---\n\n"
