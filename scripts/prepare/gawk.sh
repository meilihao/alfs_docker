#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gawk.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".gawk"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gawk-*.tar.xz -C ${BuildDir} --strip-components 1 && \
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

unset BuildDir

echo -e "+++ done gawk.sh +++\n\n"
