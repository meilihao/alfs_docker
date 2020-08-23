#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start binutils.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".binutils"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/binutils-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
expect -c "spawn ls" |grep "spawn ls"                 && \
sed -i '/@\tincremental_copy/d' gold/testsuite/Makefile.in                       && \
mkdir -v build && \
cd       build && \
../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib       && \
make tooldir=/usr                     && \
make -k check                         && \
make tooldir=/usr install             && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done binutils.sh +++\n\n"
