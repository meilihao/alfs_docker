#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start tar.sh +++\n\n"

LFS_Sources_Root=${LFSRoot}/sources
BuildDir=`mktemp -d --suffix ".tar"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/tar-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess) \
            --bindir=/bin                 && \
make           && \
make DESTDIR=$LFS install                 && \
popd           && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done tar.sh +++\n\n"
