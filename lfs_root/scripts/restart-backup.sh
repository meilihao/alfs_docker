#!/usr/bin/env bash
set -e

echo -e "--- start restart-backup.sh ---\n\n"

umount $LFS/dev{/pts,} || true     && \
umount $LFS/{sys,proc,run} || true && \

# check umount is ok
pushd /tmp && \
if [ -d ${LFS}/boot/efi ]; then
    echo -e "--- clean ${LFS}/boot/efi ---\n"
    rm -rf ${LFS}/boot/efi
fi         && \
if [ -d ${LFS}/boot ]; then
    pushd ${LFS}/boot
    echo -e "--- clean ${LFS}/boot ---\n"
    rm -rf `ls ${LFS}/boot |egrep -v efi`
    popd
fi         && \
if [ -d ${LFS} ]; then
    pushd ${LFS}
    echo -e "--- clean ${LFS} ---\n"
    rm -rf `ls ${LFS} |egrep -v "lfs_root|boot"`
    popd
fi         && \
mkdir -p ${LFS}  && \
echo -e "--- replay lfs backup ---\n" && \
tar -xpf ${LFSRoot}/lfs-backup-tmpos-${LFSVersion}.tar.xz -C ${LFS} && \
echo -e "--- sync lfs resoureces ---\n" && \
popd

${LFSRoot}/scripts/build/prepare-vkfs-again.sh
${LFSRoot}/scripts/build/lfs.sh
${LFSRoot}/scripts/build/rootfs.sh

echo -e "--- done restart-backup.sh ---\n\n"
