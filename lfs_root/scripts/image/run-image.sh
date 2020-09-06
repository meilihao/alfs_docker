#!/usr/bin/env bash
set -e

# need a machine which support uefi because grub-install use efibootmgr

echo -e "--- start run-image.sh ---\n\n"

/mnt/lfs_root/scripts/build/prepare-vkfs-again.sh

# for uefi
rsync -av /usr/lib/grub/x86_64-efi ${LFS}/usr/lib/grub
cp /usr/bin/efibootmgr $LFS/usr/bin
rsync -av /lib/x86_64-linux-gnu/{libefivar.so.1*,libefiboot.so.1*} $LFS/lib

# unpack fs root
tar -xpf /mnt/lfs_root/lfs-rootfs-${LFSVersion}.tar.xz -C ${LFS}

# generate initramfs
KernelVersion=`ls /mnt/lfs_root/sources/linux-*.tar.xz|xargs -n 1 basename |sed 's/linux-\(.*\)\.tar\.xz/\1/g'`

rsync -av $LFS/lib/modules/* /lib/modules
update-initramfs -c -k ${KernelVersion} -v -b $LFS/boot

# other
rsync -av /mnt/lfs_root/scripts/image/qemu-image.sh ${LFSRoot}

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
    -c "${LFSRootInChroot}/scripts/image/qemu-image.sh"

rm  -rf ${LFSRoot}

unset KernelVersion

echo -e "--- done run-image.sh ---\n\n"