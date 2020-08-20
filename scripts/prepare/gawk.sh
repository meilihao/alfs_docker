#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gawk.sh +++\n\n"

LFS_Sources_Root=/lfs/sources
BuildDir=`mktemp -d --suffix ".gawk"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/gawk-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i 's/extras//' Makefile.in           && \
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(./config.guess)     && \
make           && \
make DESTDIR=$LFS install                 && \
popd           && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done gawk.sh +++\n\n"
