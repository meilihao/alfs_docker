# alfs_docker - ALFS (Automated Linux From Scratch) with docker
参考:
- [reinterpretcat/lfs](https://github.com/reinterpretcat/lfs)

alfs_docker is based on [LFS-10.0-systemd](http://www.linuxfromscratch.org/lfs/download.html) for x86_64 only.

env:
- ubuntu20.04/deepin v20/debian 10
- docker 19.03.8

## [linux standards followed by LFS](https://lctt.github.io/LFS-BOOK/lfs-systemd/LFS-SYSD-BOOK.html#pre-standards)

## setp
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
$ sudo docker build . -t "lfs_builder"
$ cp -fv config/.config sources # can replace my custome .confing
$ sudo docker run --privileged -d -it -v ${PWD}/scripts:/mnt/lfs/lfs_root/scripts -v ${PWD}/iso:/mnt/lfs/lfs_root/iso -v ${PWD}/sources:/mnt/lfs/lfs_root/sources --entrypoint /bin/bash lfs_builder
$ sudo docker exec -it <container_id> bash
root@8916814e8d0d:/# vim ~/.bashrc # for MAKEFLAGS, LFS_DOCS, LFS_TEST, OnlyBuildFSRoot, BackupBeforRealInstall, LFSVersion
root@8916814e8d0d:/# source ~/.bash_profile
root@8916814e8d0d:/# $LFSRoot/scripts/run-all.sh
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
- hold "GCC plugins (GCC_PLUGINS) [Y/n/?] (NEW)" when run `scripts/build/kernel.sh`, and `CONFIG_HAVE_GCC_PLUGINS=n` does not work.
