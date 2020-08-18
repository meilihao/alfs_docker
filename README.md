# alfs_go

ALFS (Automated Linux From Scratch) with go.

alfs_go is based on [LFS-10.0-systemd](http://www.linuxfromscratch.org/lfs/download.html) for x86_64 only.

lfs version: LFS-10.0-systemd-rc1

env:
- ubuntu20.04/deepin v20/debian 10
- go 1.15

## [linux standards followed by LFS](https://lctt.github.io/LFS-BOOK/lfs-systemd/LFS-SYSD-BOOK.html#pre-standards)

## setp
### 1. check host system requirements
1. update tools/version-check.sh

1. run tools/version-check.sh
```bash
$ tools/version-check.sh  |egrep  "ERROR"
$ tools./version-check.sh  |egrep  "command not found"
```

1. fix error

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
