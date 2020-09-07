#!/usr/bin/env bash
set -e

# need a machine which support uefi because grub-install use efibootmgr

echo -e "--- start run-image.sh ---\n\n"

# unpack fs root
tar -xpf /mnt/lfs_root/lfs-rootfs-${LFSVersion}.tar.xz -C ${LFS}

# need operate /dev
/mnt/lfs_root/scripts/build/prepare-vkfs-again.sh

# other
mkdir -pv ${LFSRoot}
rsync -av /mnt/lfs_root/scripts/image/qemu-image.sh ${LFSRoot}
rsync -av /usr/share/grub/unicode.pf2 $LFS/usr/share/grub

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
    -c "${LFSRootInChroot}/qemu-image.sh"

rm  -rf ${LFSRoot}

unset KernelVersion

echo -e "--- done run-image.sh ---\n\n"