#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start file.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".file"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/file-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
mkdir -v build && \
pushd build    && \
../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib             && \
make           && \
popd           && \
./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess) && \
make           && \
make FILE_COMPILE=$(pwd)/build/src/file   && \
make DESTDIR=$LFS install                 && \
popd           && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done file.sh +++\n\n"
