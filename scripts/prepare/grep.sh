#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start grep.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".grep"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/grep-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --bindir=/bin                 && \
make           && \
make DESTDIR=$LFS install                 && \
popd           && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done grep.sh +++\n\n"
