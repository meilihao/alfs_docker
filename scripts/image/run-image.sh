#!/usr/bin/env bash
set -e
echo -e "--- start run-image.sh ---\n\n"

rm -rf /tmp/*
# may be move
rm -rf $LFS/logs

# for uefi
rsync -av /usr/lib/grub/x86_64-efi ${LFS}/usr/lib/grub
cp /usr/bin/efibootmgr $LFS/usr/bin
rsync -av /lib/x86_64-linux-gnu/{libefivar.so.1*,libefiboot.so.1*} $LFS/lib

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

echo -e "--- done run-image.sh ---\n\n"