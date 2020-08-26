#!/usr/bin/env bash
set -e
echo -e "--- start build-iso.sh ---\n\n"

# for BootableISO

pushd /tmp

cp $LFS/boot/vmlinuz-* isolinux/vmlinuz

# build iso
genisoimage -o $LFS/lfs_root/iso/lfs.iso                \
            -b isolinux/isolinux.bin  \
            -c isolinux/boot.cat      \
            -no-emul-boot             \
            -boot-load-size 4         \
            -boot-info-table .

popd

echo -e "--- done build-iso.sh ---\n\n"