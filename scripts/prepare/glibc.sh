#!/usr/bin/env bash
set -e

# `ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64` is use for chroot, so ld-linux-x86-64.so.2 isn't host's so.

echo -e "\n\n+++ start glibc.sh +++\n\n"

LFS_Sources_Root=/lfs/sources
BuildDir=`mktemp -d --suffix ".glibc"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/glibc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64                        && \
ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3     && \
patch -Np1 -i ${LFS_Sources_Root}/glibc-2.32-fhs-1.patch              && \
mkdir -v build && \
cd       build && \
../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=4.19               \
      --with-headers=$LFS/usr/include    \
      libc_cv_slibdir=/lib            && \
make                                  && \
make DESTDIR=$LFS install             && \
popd                                  && \
rm -rf ${BuildDir}

# To perform a sanity check, run the following commands
echo 'int main(){}' > dummy.c \
  && $LFS_TGT-gcc dummy.c \
  && readelf -l a.out | grep '/ld-linux' \
  && rm -v dummy.c a.out

$LFS/tools/libexec/gcc/$LFS_TGT/10.2.0/install-tools/mkheaders

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done glibc.sh +++\n\n"
