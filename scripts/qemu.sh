#!/usr/bin/env bash
set -e

# for 2.5. - 2.7.
# not use for now
# https://wiki.archlinux.org/index.php/GRUB_(%E7%AE%80%E4%BD%93%E4%B8%AD%E6%96%87)#%E7%94%9F%E6%88%90_grub.cfg

echo -e "--- start qemu.sh ---\n\n"

# qemu-img create -f <fmt> <image filename> <size of disk>
qemu-img create -f qcow2 lfs.img 8G

sudo modprobe -v nbd

sudo qemu-nbd -c /dev/nbd0 lfs.img

sudo gdisk /dev/nbd0

# see result
sudo  gdisk -l /dev/nbd0

```bash
# lsblk
nbd0         43:0    0    10G  0 disk 
├─nbd0p1     43:1    0   255M  0 part 
├─nbd0p2     43:2    0     2G  0 part 
└─nbd0p3     43:3    0   7.8G  0 part
# mkfs.fat -F32 /dev/nbd0p1
# mkfs -v -t ext4 /dev/nbd0p2
# mkfs -v -t ext4 /dev/nbd0p3
# export LFS=/mnt/lfs
# mkdir -pv $LFS
# mount -v -t ext4 /dev/nbd0p3 $LFS
# mkdir -v $LFS/boot
# mount -v -t ext4 /dev/nbd0p2 $LFS/boot
# mkdir -v $LFS/boot/efi
# mount -v -t vfat /dev/nbd0p1 $LFS/boot/efi
# grub-install /dev/nbd0
# cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0,2)

menuentry "GNU/Linux, Linux 5.8.1-lfs-10.0-systemd-rc1" {
        linux   /vmlinuz-5.8.1-lfs-10.0-systemd-rc1 root=/dev/nbd0p2 ro
}
EOF
# cp -p -R ~/test/mnt/lfs/boot/* $LFS/boot
# pushd ~/test/mnt/lfs
# cp -dpR $(ls -A | grep -Ev "boot") $LFS
# popd
# mkdir -v $LFS/boot/efi/EFI/lfs
# cd /boot
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=lfs
# umount $LFS/boot/efi
# umount $LFS/boot
# umount $LFS
```

# --efi-directory 替代了已经废弃的 --root-directory
# grub-install --target=x86_64-efi --efi-directory=efi --bootloader-id=lfs
grub-install: error: /usr/lib/grub/x86_64-efi/modinfo.sh doesn't exist. Please specify --target or --directory
# 缺grub2-efi-modules, `sudo cp -rf x86_64-efi /mnt/lfs/usr/lib/grub`即可
# ---
# grub-install --target=x86_64-efi --efi-directory=efi --bootloader-id=lfs
Installing for x86_64-efi platform.
grub-install: error: cannot find a device for efi (is /dev mounted?)
# chroot环境未挂载dev, 见 lfs 7.3. 准备虚拟内核文件系统 
# ---
# grub-install --target=x86_64-efi --efi-directory=efi --bootloader-id=lfs
Installing for x86_64-efi platform.
grub-install: error: efibootmgr: not found.
# sudo cp /usr/bin/efibootmgr /mnt/lfs/usr/bin/
# sudo cp /lib/x86_64-linux-gnu/libefivar.so.1 /mnt/lfs/lib
# ---
# qemu-img dd -f qcow2 -O raw bs=4M if=/vm-images/image.qcow2 of=/dev/sdd1 # 支持将qcow2 dd到磁盘

qemu-nbd --disconnect /dev/nbd0

echo -e "--- done qemu.sh ---\n\n"