#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start binutils2.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".binutils2"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/binutils-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
mkdir -v build && \
cd build       && \
../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --disable-werror           \
    --enable-64-bit-bfd     && \
make           && \
make DESTDIR=$LFS install   && \
popd           && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done binutils2.sh +++\n\n"
