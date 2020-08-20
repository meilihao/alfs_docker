#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gzip.sh +++\n\n"

LFS_Sources_Root=/lfs/sources
BuildDir=`mktemp -d --suffix ".gzip"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/gzip-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --host=$LFS_TGT && \
make           && \
make DESTDIR=$LFS install                 && \
mv -v $LFS/usr/bin/gzip $LFS/bin          && \
popd           && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done gzip.sh +++\n\n"
