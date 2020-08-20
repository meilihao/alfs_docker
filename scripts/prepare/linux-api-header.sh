#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start linux-api-header.sh +++\n\n"

LFS_Sources_Root=/lfs/sources
BuildDir=`mktemp -d --suffix ".linux-api-header"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/linux-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
make mrproper  && \
make headers   && \
find usr/include -name '.*' -delete && \
rm usr/include/Makefile             && \
cp -rv usr/include $LFS/usr         && \
popd           && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done linux-api-header.sh +++\n\n"
