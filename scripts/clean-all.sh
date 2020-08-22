#!/usr/bin/env bash
set -e

echo -e "--- start clean-all.sh ---\n\n"

# clean env
unset DEBIAN_FRONTEND

LFS_Build_Done=~/.lfs_build_done

if [ -f ${LFS_Build_Done} ]; then
    echo -e "--- clean ${LFS_Build_Done}\n"
    rm ${LFS_Build_Done}
fi

mountpoint -q $LFS/dev/pts && umount $LFS/dev/pts
mountpoint -q $LFS/dev && umount $LFS/dev
mountpoint -q $LFS/sys && umount $LFS/sys
mountpoint -q $LFS/proc && umount $LFS/proc
mountpoint -q $LFS/run && umount $LFS/run

echo -e "--- clean ${LFS}\n"
pushd ${LFS}
rm -rf `ls ${LFS} |egrep -v lfs_root`
popd

rm -rf /tmp/*

echo -e "--- done clean-all.sh ---\n\n"
