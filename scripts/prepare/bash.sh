#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start bash.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".bash"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/bash-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr                   \
            --build=$(support/config.guess) \
            --host=$LFS_TGT                 \
            --without-bash-malloc        && \
make           && \
make DESTDIR=$LFS install            && \
mv $LFS/usr/bin/bash $LFS/bin/bash   && \
ln -sv bash $LFS/bin/sh              && \
popd           && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done bash.sh +++\n\n"
