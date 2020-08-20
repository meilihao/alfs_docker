# alfs_docker
参考:
- [reinterpretcat/lfs](https://github.com/reinterpretcat/lfs)

ALFS (Automated Linux From Scratch) with docker.

alfs_docker is based on [LFS-10.0-systemd](http://www.linuxfromscratch.org/lfs/download.html) for x86_64 only.

lfs version: LFS-10.0-systemd-rc1

env:
- ubuntu20.04/deepin v20/debian 10
- docker 19.03.8

## [linux standards followed by LFS](https://lctt.github.io/LFS-BOOK/lfs-systemd/LFS-SYSD-BOOK.html#pre-standards)

## setp
### 1. update version-check.sh
1. update scripts/version-check.sh

### 1. download linux kernel build config
```bash
$ wget https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.8.2/amd64/linux-headers-5.8.2-050802-generic_5.8.2-050802.202008190732_amd64.deb
$ dpkg -x linux-hea    ders-5.8.2-050802-generic_5.8.2-050802.202008190732_amd64.deb tmp
$ cp tmp/usr/src/linux-headers-5.8.2-050802-generic/.config config
```

### 1. download all packages and patches
a tarball of all the needed files can be downloaded from one of the LFS files mirrors listed at http://www.linuxfromscratch.org/mirrors.html#files.

```bash
$ wget --continue --directory-prefix=sources https://mirror-hk.koddos.net/lfs/lfs-packages/lfs-packages-10.0-rc1.tar
$ wget --directory-prefix=sources https://mirror-hk.koddos.net/lfs/lfs-packages/SHA1SUMS
$ cat sources/SHA1SUMS |grep "lfs-packages-10.0-rc1" > sources/target_sum
$ cd sources && sha1sum -c target_sum
$ cd ..
```

> or mirror: http://mirrors.ustc.edu.cn/lfs/lfs-packages/lfs-packages-10.0-rc1.tar

### 1. build docker
> docker debug cmd: sudo docker run --rm -it ubuntu:20.04 bash

```bash
$ sudo docker run --rm -it [-v ${PWD}/iso:/lfs/iso -v ${PWD}/sources:/lfs/sources] lfs_builder
```
