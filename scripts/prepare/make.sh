#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start make.sh +++\n\n"

LFS_Sources_Root=${LFSRoot}/sources
BuildDir=`mktemp -d --suffix ".make"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/make-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess) && \
make           && \
make DESTDIR=$LFS install                 && \
popd           && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done make.sh +++\n\n"
