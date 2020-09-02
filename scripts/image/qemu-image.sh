#!/usr/bin/env bash
set -e
echo -e "--- start qemu-image.sh ---\n\n"

# Creating the /etc/fstab File
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# 文件系统     挂载点       类型     选项                转储  检查
#                                                              顺序
UUID=D1F7-D179		                     /boot/efi    vfat    rw,relatime,fmask=0022,dmask=0022,codepage=437,iocharset=ascii,shortname=mixed,utf8,errors=remount-ro    1 2
UUID=7c5e5590-9f32-4882-a6a1-fabb7d91fa4b    /boot    ext4    noauto,noatime    1 2
UUID=9767098f-4749-4855-bb5e-8a775e498f1b    /        ext4    noatime	        0 1

# End /etc/fstab
EOF

echo -e "--- done /etc/fstab ---\n\n"

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=lfs --recheck --debug

grub-mkconfig -o /boot/grub/grub.cfg

cat > /boot/efi/EFI/lfs/grub.cfg << "EOF"
search.fs_uuid 7c5e5590-9f32-4882-a6a1-fabb7d91fa4b root
set prefix=($root)'/grub'
configfile $prefix/grub.cfg
EOF

cp -r /boot/efi/EFI/lfs /boot/efi/EFI/boot
cp /boot/efi/EFI/boot/grubx64.efi /boot/efi/EFI/boot/bootx64.efi

echo -e "--- done set grub ---\n\n"

echo -e "--- done qemu-image.sh ---\n\n"