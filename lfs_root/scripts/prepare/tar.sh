#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start tar.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".tar"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/tar-*.tar.xz -C ${BuildDir} --strip-components 1 && \
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

unset BuildDir

echo -e "+++ done tar.sh +++\n\n"
