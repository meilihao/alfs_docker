#!/usr/bin/env bash
set -e

# `ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64` is use for chroot, so ld-linux-x86-64.so.2 isn't host's so.
# delete ld-lsb-x86-64.so.3, because not found it in ubuntu 20.04 or deepin v20

echo -e "\n\n+++ start glibc.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".glibc"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/glibc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64                        && \
# ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3     && \
patch -Np1 -i ${LFSRoot}/sources/glibc-2.33-fhs-1.patch              && \
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
  && readelf -l a.out | grep '/ld-linux' | grep '/lib64/ld-linux-x86-64.so.2' \
  && rm -v dummy.c a.out

$LFS/tools/libexec/gcc/$LFS_TGT/10.2.0/install-tools/mkheaders

unset BuildDir

echo -e "+++ done glibc.sh +++\n\n"
