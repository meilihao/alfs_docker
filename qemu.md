# qemu for bootable qcow2 image
参考:
- [gentoo's Quick_Installation_Checklist](https://wiki.gentoo.org/wiki/Quick_Installation_Checklist)
- [使用grub2制作U盘引导iso](http://xstarcd.github.io/wiki/Linux/boot-multiple-iso-from-usb-via-grub2-using-linux.html)
- [GRUB](https://wiki.archlinux.org/index.php/GRUB)
- [grub2详解(翻译和整理官方手册)](https://www.lagou.com/lgeduarticle/9097.html)

## prepare qcow2 image
```bash
$ qemu-img create -f qcow2 lfs.img 8G # qemu-img create -f <fmt> <image filename> <size of disk>
$ sudo modprobe -v nbd
$ sudo qemu-nbd -c /dev/nbd0 lfs.img
$ sudo gdisk /dev/nbd0 # or use script
# sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo gdisk /dev/nbd0
  o # new gpt
  Y # Proceed
  n # new partition
  1 # Partition number
    # default - start at beginning of disk
  +1M # 1 MB BIOS boot partition
  ef02  # new partition
  n
  2

  +256M
  ef00 # EFI System
  n
  3

  +2048M
  8300
  n
  4
  
  
  
  w # write GPT data
  Y # want to proceed
EOF
$ sudo gdisk -l /dev/nbd0
GPT fdisk (gdisk) version 1.0.3

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/nbd0: 16777216 sectors, 8.0 GiB
Sector size (logical/physical): 512/512 bytes
Disk identifier (GUID): 7BA7343F-4654-4DB5-8732-D55BF7C759CC
Partition table holds up to 128 entries
Main partition table begins at sector 2 and ends at sector 33
First usable sector is 34, last usable sector is 16777182
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048            4095   1024.0 KiB  EF02  BIOS boot partition
   2            4096          528383   256.0 MiB   EF00  EFI System
   3          528384         4722687   2.0 GiB     8300  Linux filesystem
   4         4722688        16777182   5.7 GiB     8300  Linux filesystem
$ sudo hd /dev/nbd0 -n 512 # see disk head
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001c0  02 00 ee ff ff ff 01 00  00 00 ff ff ff 00 00 00  |................|
000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
00000200
$ sudo docker run --privileged -d -it --entrypoint /bin/bash ubuntu:20.04
314e2de3097dfbdc58f5d236c2c244718273afc601cb67f67e952e53a3a44513
$ sudo docker cp ./lfs-fsroot.tar.gz 314e2de3097dfbdc58f5d236c2c244718273afc601cb67f67e952e53a3a44513:/lfs_fs_root.tar.gz
$ sudo docker exec -it 314e2de3097dfbdc58f5d236c2c244718273afc601cb67f67e952e53a3a44513 bash
# sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
# apt udpate && apt install -y rsync bsdmainutils grub-efi-amd64-bin # bsdmainutils for hd
# export LFSFSRoot=/lfs_fs_root # in docker now
# export LFS=/mnt/lfs
# mkdir -pv $LFSFSRoot
# mkdir -pv $LFS
# tar -xf lfs_fs_root.tar.gz -C ${LFSFSRoot} --strip-components 2
# ls -al ${LFSFSRoot}
total 84
drwxr-xr-x 21 root root 4096 Aug 28 17:05 .
drwxr-xr-x  1 root root 4096 Aug 28 17:05 ..
drwxr-xr-x  2 root root 4096 Aug 27 05:07 bin
drwxr-xr-x  2 root root 4096 Aug 27 07:02 boot
drwxr-xr-x  2 root root 4096 Aug 27 02:51 dev
drwxr-xr-x 22 root root 4096 Aug 27 07:02 etc
drwxr-xr-x  2 root root 4096 Aug 27 05:05 home
drwxr-xr-x  7 root root 4096 Aug 27 07:01 lib
drwxr-xr-x  2 root root 4096 Aug 27 02:10 lib64
drwxr-xr-x  4 root root 4096 Aug 27 02:51 media
drwxr-xr-x  2 root root 4096 Aug 27 02:51 mnt
drwxr-xr-x  2 root root 4096 Aug 27 02:51 opt
drwxr-xr-x  2 root root 4096 Aug 27 02:51 proc
drwxr-x---  2 root root 4096 Aug 27 04:26 root
drwxr-xr-x  2 root root 4096 Aug 27 02:51 run
drwxr-xr-x  2 root root 4096 Aug 27 04:58 sbin
drwxr-xr-x  2 root root 4096 Aug 27 02:51 srv
drwxr-xr-x  2 root root 4096 Aug 27 02:51 sys
drwxrwxrwt  2 root root 4096 Aug 27 07:02 tmp
drwxr-xr-x 11 root root 4096 Aug 27 05:05 usr
drwxr-xr-x 10 root root 4096 Aug 27 02:51 var
# fdisk -l /dev/nbd0
...
Device        Start      End  Sectors  Size Type
/dev/nbd0p1    2048     4095     2048    1M BIOS boot
/dev/nbd0p2    4096   528383   524288  256M EFI System
/dev/nbd0p3  528384  4722687  4194304    2G Linux filesystem
/dev/nbd0p4 4722688 16777182 12054495  5.8G Linux filesystem
```

本文支持两种引导:
- BIOS/GPT
- UEFI/GPT

  uefi情况下, uefi固件会忽略`EF02  BIOS boot partition`分区.

### BIOS/GPT
```bash
# mkfs -v -t ext4 /dev/nbd0p4
# mount -v -t ext4 /dev/nbd0p4 $LFS
# mkdir -pv $LFS/boot
# mkfs -v -t ext4 /dev/nbd0p3
# mount -v -t ext4 /dev/nbd0p3 $LFS/boot
# ---  no need `--update`, `--dry-run` only for debug
# rsync -av ${LFSFSRoot}/boot/* ${LFS}/boot
# rsync -av --exclude="boot" ${LFSFSRoot}/* ${LFS}

# mount -v --bind /dev $LFS/dev
# mount -v --bind /dev/pts $LFS/dev/pts
# mount -vt proc proc $LFS/proc
# mount -vt sysfs sysfs $LFS/sys
# mount -vt tmpfs tmpfs $LFS/run
# chroot "$LFS" /usr/bin/env -i \ # in chroot
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login
# cat > /etc/fstab << "EOF"
# 文件系统     挂载点       类型     选项                转储  检查
#                                                              顺序
UUID=e3cee0eb-3fc4-4110-94e7-8250efb3a798    /boot    ext4    noauto,noatime    1 2
UUID=205568c4-5199-4e81-9227-696c9f824ee2    /        ext4    noatime	        0 1

EOF
# grub-install --target=i386-pc --recheck /dev/nbd0
Installing for i386-pc platform.
Installation finished. No error reported.
# grub-mkconfig -o /boot/grub/grub.cfg
# exit # exit chroot
# hd /dev/nbd0 -n 512 # check MBR
00000000  eb 63 90 00 00 00 00 00  00 00 00 00 00 00 00 00  |.c..............|
00000010  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000050  00 00 00 00 00 00 00 00  00 00 00 80 00 08 00 00  |................|
00000060  00 00 00 00 ff fa 90 90  f6 c2 80 74 05 f6 c2 70  |...........t...p|
00000070  74 02 b2 80 ea 79 7c 00  00 31 c0 8e d8 8e d0 bc  |t....y|..1......|
00000080  00 20 fb a0 64 7c 3c ff  74 02 88 c2 52 be 80 7d  |. ..d|<.t...R..}|
00000090  e8 17 01 be 05 7c b4 41  bb aa 55 cd 13 5a 52 72  |.....|.A..U..ZRr|
000000a0  3d 81 fb 55 aa 75 37 83  e1 01 74 32 31 c0 89 44  |=..U.u7...t21..D|
000000b0  04 40 88 44 ff 89 44 02  c7 04 10 00 66 8b 1e 5c  |.@.D..D.....f..\|
000000c0  7c 66 89 5c 08 66 8b 1e  60 7c 66 89 5c 0c c7 44  ||f.\.f..`|f.\..D|
000000d0  06 00 70 b4 42 cd 13 72  05 bb 00 70 eb 76 b4 08  |..p.B..r...p.v..|
000000e0  cd 13 73 0d 5a 84 d2 0f  83 d8 00 be 8b 7d e9 82  |..s.Z........}..|
000000f0  00 66 0f b6 c6 88 64 ff  40 66 89 44 04 0f b6 d1  |.f....d.@f.D....|
00000100  c1 e2 02 88 e8 88 f4 40  89 44 08 0f b6 c2 c0 e8  |.......@.D......|
00000110  02 66 89 04 66 a1 60 7c  66 09 c0 75 4e 66 a1 5c  |.f..f.`|f..uNf.\|
00000120  7c 66 31 d2 66 f7 34 88  d1 31 d2 66 f7 74 04 3b  ||f1.f.4..1.f.t.;|
00000130  44 08 7d 37 fe c1 88 c5  30 c0 c1 e8 02 08 c1 88  |D.}7....0.......|
00000140  d0 5a 88 c6 bb 00 70 8e  c3 31 db b8 01 02 cd 13  |.Z....p..1......|
00000150  72 1e 8c c3 60 1e b9 00  01 8e db 31 f6 bf 00 80  |r...`......1....|
00000160  8e c6 fc f3 a5 1f 61 ff  26 5a 7c be 86 7d eb 03  |......a.&Z|..}..|
00000170  be 95 7d e8 34 00 be 9a  7d e8 2e 00 cd 18 eb fe  |..}.4...}.......|
00000180  47 52 55 42 20 00 47 65  6f 6d 00 48 61 72 64 20  |GRUB .Geom.Hard |
00000190  44 69 73 6b 00 52 65 61  64 00 20 45 72 72 6f 72  |Disk.Read. Error|
000001a0  0d 0a 00 bb 01 00 b4 0e  cd 10 ac 3c 00 75 f4 c3  |...........<.u..|
000001b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
000001c0  02 00 ee ff ff ff 01 00  00 00 ff ff ff 00 00 00  |................|
000001d0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
000001f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 55 aa  |..............U.|
00000200
# umount $LFS/dev{/pts,}
# umount $LFS/{sys,proc,run}
# umount $LFS/{boot,}
# --- exit container
# exit
$ sudo qemu-nbd --disconnect /dev/nbd0
$ qemu-system-x86_64 -enable-kvm -m 1024 -hda lfs.img
```

效果图:
![](/misc/img/gpt_bios_grub.png)
![](/misc/img/gpt_kernel.png)

### uefi
```bash
# mkfs -v -t ext4 /dev/nbd0p4
# mount -v -t ext4 /dev/nbd0p4 $LFS
# mkdir -pv $LFS/boot
# mkfs -v -t ext4 /dev/nbd0p3
# mount -v -t ext4 /dev/nbd0p3 $LFS/boot
# mkdir -pv $LFS/boot/efi
# mkfs.fat -F 32 /dev/nbd0p2
# mount -v -t vfat /dev/nbd0p2 $LFS/boot/efi
# rsync -av ${LFSFSRoot}/boot/* ${LFS}/boot
# rsync -av --exclude="boot" ${LFSFSRoot}/* ${LFS}
# --- 避免grub-install时报错
# rsync -av /usr/lib/grub/x86_64-efi ${LFS}/usr/lib/grub
# cp /usr/bin/efibootmgr $LFS/usr/bin
# rsync -av /lib/x86_64-linux-gnu/{libefivar.so.1*,libefiboot.so.1*} $LFS/lib

# mount -v --bind /dev $LFS/dev
# mount -v --bind /dev/pts $LFS/dev/pts
# mount -vt proc proc $LFS/proc
# mount -vt sysfs sysfs $LFS/sys
# mount -vt tmpfs tmpfs $LFS/run
# --- into chroot
# chroot "$LFS" /usr/bin/env -i \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login
# cat > /etc/fstab << "EOF"
# 文件系统     挂载点       类型     选项                转储  检查
#                                                              顺序
UUID=D1F7-D179		                     /boot/efi    vfat    noauto,noatime    1 2
UUID=7c5e5590-9f32-4882-a6a1-fabb7d91fa4b    /boot    ext4    noauto,noatime    1 2
UUID=9767098f-4749-4855-bb5e-8a775e498f1b    /        ext4    noatime	        0 1

EOF
# grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=lfs --debug # bootloader-id=lfs指`/boot/efi/EFI/${bootloader-id}`, `--efi-directory`替代了已经废弃的`--root-directory`.
...
BootCurrent: 0000
Timeout: 0 seconds
BootOrder: 0001,0000,0003,0002,2001,2002,2003
Boot0000* deepin
...
Boot0001* lfs
Installation finished. No error reported.
# grub-mkconfig -o /boot/grub/grub.cfg
# --- exit chroot
# exit
# umount $LFS/dev{/pts,}
# umount $LFS/{sys,proc,run}
# umount $LFS/{boot/efi,boot,}
# exit container
$ sudo qemu-nbd --disconnect /dev/nbd0
$ qemu-system-x86_64 -bios "/usr/share/ovmf/OVMF.fd" -enable-kvm -m 1024 -hda lfs.img
```

效果图:
![](/misc/img/)
![](/misc/img/)

## FAQ
### grub.cfg手动配置(**不推荐, 未测试**)
```bash
# cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0,2)

menuentry "GNU/Linux, Linux 5.8.1-lfs-10.0-systemd-rc1" {
        linux   /vmlinuz-5.8.1-lfs-10.0-systemd-rc1 root=/dev/sda2 ro
}
EOF
```

### grub-install报错: "/usr/lib/grub/i386-pc/modinfo.sh doesn't exist. Please specify --target or --directory"
当时执行的是`grub-install --target=i386-pc --recheck /dev/nbd0`.

解决方法: `sudo apt-get install grub-pc-bin`.

### grub-install: error: /usr/lib/grub/x86_64-efi/modinfo.sh doesn't exist. Please specify --target or --directory
当时执行的是`grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=lfs`.

解决方法: `sudo apt-get install grub-efi-amd64-bin`.

### grub-install: error: efibootmgr: not found.
当时执行的是`grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=lfs`.

解决方法: `cp /usr/bin/efibootmgr /mnt/lfs/usr/bin && sudo cp /lib/x86_64-linux-gnu/libefivar.so.1 /mnt/lfs/lib

### mkfs vfat报错: "Your mke2fs.conf file does not define the vfat filesystem type"
当前系统不支持vfat.

解决方法: `sudo apt-get install dosfstools`.

### 如何将qcow2打内容克隆到磁盘
`qemu-img dd -f qcow2 -O raw bs=4M if=/vm-images/image.qcow2 of=/dev/sdd1`支持将qcow2 dd到磁盘







http://lists.linuxfromscratch.org/pipermail/hints/2018-April/003325.html

:~# grub-install --bootloader-id=lfs --recheck --debug > a.log 2>&1 
(lfs chroot) root:~#  grep "unicode.pf2" grub.log
grep: grub.log: No such file or directory
(lfs chroot) root:~#  grep "unicode.pf2" a.log   
grub-install: info: copying `/usr/share/grub/unicode.pf2' -> `/boot/grub/fonts/unicode.pf2'.
grub-install: info: cannot open `/usr/share/grub/unicode.pf2': No such file or directory.