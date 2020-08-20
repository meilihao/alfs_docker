#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start bash.sh +++\n\n"

LFS_Sources_Root=/lfs/sources
BuildDir=`mktemp -d --suffix ".bash"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/bash-*.tar.gz -C ${BuildDir} --strip-components 1 && \
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

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done bash.sh +++\n\n"
