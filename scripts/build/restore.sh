#!/usr/bin/env bash
set -e

# no test becasue use qemu nbd mount on ${LFS}/{,boot, boot/efi}

echo -e "--- start run-restore.sh ---\n\n"

umount $LFS/dev{/pts,} || true     && \
umount $LFS/{sys,proc,run} || true && \

# check umount is ok
pushd ${LFS} && \
rm -rf `ls ${LFS} |egrep -v lfs_root` && \
tar -xpf /mnt/lfs-temp-tools-${LFSVersion}.tar.gz && \
popd

echo -e "--- done run-restore.sh ---\n\n"
