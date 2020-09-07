#!/usr/bin/env bash
set -e
echo -e "--- start rootfs.sh ---\n\n"

umount $LFS/dev{/pts,} || true
umount $LFS/{sys,proc,run} || true

# for uefi
rsync -av /usr/lib/grub/x86_64-efi ${LFS}/usr/lib/grub
cp /usr/bin/efibootmgr $LFS/usr/bin
rsync -av /lib/x86_64-linux-gnu/{libefivar.so.1*,libefiboot.so.1*} $LFS/lib

# generate initramfs
KernelVersion=`ls ${LFSRoot}/sources/linux-*.tar.xz|xargs -n 1 basename |sed 's/linux-\(.*\)\.tar\.xz/\1/g'`

rsync -av $LFS/lib/modules/* /lib/modules
# --- 不使用ln, 因为容易出错导致$LFS/lib/modules/*被修改
# mkdir -pv /lib/modules
# ln -sv $LFS/lib/modules/${KernelVersion}  /lib/modules/${KernelVersion}
update-initramfs -c -k ${KernelVersion} -v -b $LFS/boot

pushd $LFS && \
if [ -f ${LFSRoot}/lfs-rootfs-${LFSVersion}.tar.xz ]; then
    mv -v ${LFSRoot}/lfs-rootfs-${LFSVersion}.tar.xz ${LFSRoot}/lfs-rootfs-${LFSVersion}-`date +%s`.tar.xz
fi         && \
tar --exclude=lfs_root --exclude=logs -cJpf ${LFSRoot}/lfs-rootfs-${LFSVersion}.tar.xz . && \
popd

unset KernelVersion

echo -e "--- done rootfs.sh ---\n\n"
