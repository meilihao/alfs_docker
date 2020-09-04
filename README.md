# alfs_docker - ALFS (Automated Linux From Scratch) with docker
参考:
- [reinterpretcat/lfs](https://github.com/reinterpretcat/lfs)

alfs_docker is based on [LFS-10.0-systemd](http://www.linuxfromscratch.org/lfs/download.html) for x86_64 only.

env:
- ubuntu20.04/deepin v20/debian 10
- docker 19.03.8

## [linux standards followed by LFS](https://lctt.github.io/LFS-BOOK/lfs-systemd/LFS-SYSD-BOOK.html#pre-standards)

## setp
**note**:
1. need a machine which support uefi because grub-install use efibootmgr, Otherwise use tag 1.0 which support bios+gpt.

### 1. update version-check.sh
1. update scripts/version-check.sh

### 1. download linux kernel build config
download `.config` need match sources/linux-*.tar.xz's version.

```bash
$ export ALFSDockerRoo=~/git/alfs_docker
$ pushd /tmp
$ wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.8.3/amd64/linux-headers-5.8.3-050803-generic_5.8.3-050803.202008211236_amd64.deb
$ dpkg -x linux-headers-*.deb tmp
$ cp tmp/usr/src/linux-headers-*-generic/.config ${ALFSDockerRoo}/config
```

> custom .config is in [here](/config/.config.replace), **recommand**

### 1. download all packages and patches
a tarball of all the needed files can be downloaded from one of the LFS files mirrors listed at http://www.linuxfromscratch.org/mirrors.html#files.

```bash
$ wget --continue https://mirror-hk.koddos.net/lfs/lfs-packages/lfs-packages-10.0.tar
$ wget https://mirror-hk.koddos.net/lfs/lfs-packages/SHA1SUMS
$ cat SHA1SUMS |grep "lfs-packages-10.0.tar" > lfs-sum
$ sha1sum -c lfs-sum
$ tar -xvf lfs-packages-10.0.tar
$ mv 10.0 ${ALFSDockerRoo}/sources
$ popd
```

> or mirror for china: http://mirrors.ustc.edu.cn/lfs/lfs-packages/lfs-packages-10.0.tar

### 1. update args
1. glibc compatible : use host's glibc version

    1. ${ALFSDockerRoo}/scripts/prepare/gcc.sh : --with-glibc-version=2.31 # docker base image(ubuntu 20.04)'s glibc version

1. kernel compatible for glibc

    1. ${ALFSDockerRoo}/scripts/prepare/glibc.sh : --enable-kernel=4.19 # my host(debian 10) kernel version
    1. ${ALFSDockerRoo}/scripts/build/glibc.sh : --enable-kernel=4.19

### 1. build docker image and run it
> docker debug cmd: sudo docker run --rm -it ubuntu:20.04 bash

```bash
$ wget --continue --directory-prefix=sources https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-6.03.tar.gz
$ wget --continue --directory-prefix=sources https://ftp.gnu.org/gnu/cpio/cpio-2.13.tar.gz
$ curl https://git.savannah.gnu.org/cgit/cpio.git/patch/?id=641d3f489cf6238bb916368d4ba0d9325a235afb -o sources/cpio-2.13.patch
$ wget https://codeload.github.com/lz4/lz4/tar.gz/v1.9.2 -O sources/lz4-1.9.2.tar.gz
$ git clone --depth=1 https://github.com/ohmybash/oh-my-bash.git sources/oh-my-bash
$ sudo docker build . -t "lfs_builder"
$ cp -fv config/.config sources # can replace my custome .confing
$ qemu-img create -f qcow2 lfs.img 16G # qemu-img create -f <fmt> <image filename> <size of disk>
$ sudo modprobe -v nbd
$ sudo qemu-nbd -c /dev/nbd0 lfs.img
$ sudo scripts/gdisk.sh
$ sudo docker run --privileged -d -it -v ${PWD}/scripts:/mnt/lfs_root/scripts -v ${PWD}/sources:/mnt/lfs_root/sources --entrypoint /bin/bash lfs_builder # --privileged for mount in container
$ sudo docker exec -it 401ccde8d881 bash
root@401ccde8d881:/# /mnt/lfs_root/scripts/version-check.sh # for check env
root@401ccde8d881:/# /mnt/lfs_root/scripts/mount_lfs.sh     # for partition
root@401ccde8d881:/# mount                                  # check mount, $LFS{,boot,boot/efi} is ok?
root@401ccde8d881:/# /mnt/lfs_root/scripts/sync2lfs.sh   # sync to lfs for chroot environment
root@401ccde8d881:/# vim ~/.bashrc                       # for MAKEFLAGS, LFS_DOCS, LFS_TEST, BackupBeforRealInstall, LFSVersion
root@401ccde8d881:/# source ~/.bash_profile
root@401ccde8d881:/# $LFSRoot/scripts/run-all.sh  2>&1 |tee build.log  # start build lfs
root@401ccde8d881:/# vim $LFS/etc/fstab                  # set right fstab, see qemu.md
root@401ccde8d881:/# vim $LFS/boot/efi/EFI/lfs/grub.cfg  # set right /boot uuid, see qemu.md
root@401ccde8d881:/# vim $LFS/boot/grub/grub.cfg         # fix rootfs when generate grub.cfg, see qemu.md
root@401ccde8d881:/# /mnt/lfs_root/scripts/image/done.sh # umount /dev/nbd0pN, use /mnt/lfs_root/scripts/image/done.sh because ${LFSRoot} deleted in build/cleanup2.sh
root@401ccde8d881:/# mount # check mount
root@401ccde8d881:/# exit
$ sudo qemu-nbd -d /dev/nbd0
$ cp /usr/share/ovmf/OVMF.fd .
$ qemu-system-x86_64 -M q35 -pflash OVMF.fd -enable-kvm -m 1024 -hda lfs.img
```

#### restore
```bash
# root@ddcd5d6dc98d:/#  /mnt/lfs_root/scripts/restore.sh # in docker
```


**note**, that extended privileges are required by docker container in order to execute some commands (e.g. mount, `mount -v --bind /dev $LFS/dev`).

#### 1. change lfs-fsroot.zip -> Bootable qcow2 image
see [qemu.md](qemu.md), support `bios/gpt` and `efi/gpt`

bootable qcow2 image with efi is [here](https://pan.baidu.com/s/1usXAdzzMk85a7HYbcC2sRg), auth code is `1x3a`.

## update lfs
1. downlaod latest lfs from [http://linuxfromscratch.org/lfs/downloads/](http://linuxfromscratch.org/lfs/downloads/)
1. delete content before "Chapter 4. Final Preparations" to reduce interference for compare
1. compare current version with latest by `Beyond Compare`
1. update script`
1. build lfs again for test

## useful tools
1. `tar -tvf gcc-*.tar.xz` # list files in tar.xz
1. `watch -n 10 "ps -ef |grep bash"` # watch processing when lost direct log with ssh broken

## log
offical log for compare: http://www.linuxfromscratch.org/lfs/build-logs/10.0/

> log order not match because may be MAKEFLAGS

## issue
- hold "GCC plugins (GCC_PLUGINS) [Y/n/?] (NEW)" when run `scripts/build/kernel.sh`, and `CONFIG_HAVE_GCC_PLUGINS=n` does not work and make report "Restart config..."

    初步排查是`scripts/kconfig/conf.c`提示了`Restart config`, 待查???.

## roadmap
see [changelog.md](/changelog.md)

## changelog
see [changelog.md](/changelog.md)