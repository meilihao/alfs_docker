#!/usr/bin/env bash
set -e
echo -e "--- start rootfs.sh ---\n\n"

umount $LFS/dev{/pts,} || true
umount $LFS/{sys,proc,run} || true

pushd $LFS && \
if [ -f ${LFSRoot}/lfs-rootfs-${LFSVersion}.tar.xz ]; then
    mv -v ${LFSRoot}/lfs-rootfs-${LFSVersion}.tar.xz ${LFSRoot}/lfs-rootfs-${LFSVersion}-`date +%s`.tar.xz
fi         && \
tar --exclude=lfs_root --exclude=logs -cJpf ${LFSRoot}/lfs-rootfs-${LFSVersion}.tar.xz . && \
popd

echo -e "--- done rootfs.sh ---\n\n"
