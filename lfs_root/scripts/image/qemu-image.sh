#!/usr/bin/env bash
set -e

# if machine not support efi, will get error:
# grub-install: error: efibootmgr failed to register the boot entry: No such file or directory
# 在no uefi环境下配置uefi, grub-install会报错, 且此后手动配置grub比较繁琐并容易出错,比如efibootmgr添加启动项后,qemu启动images时仍会进入uefi shell. 因此建议在uefi的环境下配置grub. 不过此种情况可先用
# 解决方法: 先通过uefi shell手动选择启动项登入系统, 再执行`grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=lfs --recheck --debug`修改grub配置, 最后重启即可.

echo -e "--- start qemu-image.sh ---\n\n"

# Creating the /etc/fstab File
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# <file system> <mount point>   <type>  <options>       <dump>  <pass>
UUID=D1F7-D179		                     /boot/efi    vfat    rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro    1 2
UUID=7c5e5590-9f32-4882-a6a1-fabb7d91fa4b    /boot    ext4    noauto,noatime    1 2
UUID=9767098f-4749-4855-bb5e-8a775e498f1b    /        ext4    noatime	        0 1

# End /etc/fstab
EOF

echo -e "--- done /etc/fstab ---\n\n"

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=lfs --recheck --debug

grub-mkconfig -o /boot/grub/grub.cfg

# 7c5e5590-9f32-4882-a6a1-fabb7d91fa4b is /boot's uuid
cat > /boot/efi/EFI/lfs/grub.cfg << "EOF"
search.fs_uuid 7c5e5590-9f32-4882-a6a1-fabb7d91fa4b root
set prefix=($root)'/grub'
configfile $prefix/grub.cfg
EOF

# grub-install set boot item to /boot/efi/EFI/lfs/grubx64.efi
# cp -r /boot/efi/EFI/lfs /boot/efi/EFI/boot
# cp /boot/efi/EFI/boot/grubx64.efi /boot/efi/EFI/boot/bootx64.efi

echo -e "--- done set grub ---\n\n"

echo -e "--- done qemu-image.sh ---\n\n"