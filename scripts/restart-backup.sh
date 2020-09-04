#!/usr/bin/env bash
set -e

# no test becasue use qemu nbd mount on ${LFS}/{,boot, boot/efi}

echo -e "--- start run-restore.sh ---\n\n"

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
tar -xpf /mnt/lfs-backup-tools-${LFSVersion}.tar.xz -C ${LFS} && \
echo -e "--- sync lfs resoureces ---\n" && \
/mnt/lfs_root/scripts/sync2lfs.sh     && \
popd

/mnt/lfs_root/scripts/build/prepare-vkfs-again.sh
/mnt/lfs_root/scripts/build/lfs.sh
/mnt/lfs_root/scripts/image/run-image.sh

echo -e "--- done run-restore.sh ---\n\n"
