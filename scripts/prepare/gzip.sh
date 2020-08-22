#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gzip.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".gzip"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gzip-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --host=$LFS_TGT && \
make           && \
make DESTDIR=$LFS install                 && \
mv -v $LFS/usr/bin/gzip $LFS/bin          && \
popd           && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done gzip.sh +++\n\n"
