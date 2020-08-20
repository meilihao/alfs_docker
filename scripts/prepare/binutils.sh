#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start binutils.sh +++\n\n"

# put LFS_Sources_Root here to allow running build script directly
LFS_Sources_Root=/lfs/sources
BuildDir=`mktemp -d --suffix ".binutils"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/binutils-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
mkdir -v build && \
cd build       && \
../configure --prefix=$LFS/tools       \
             --with-sysroot=$LFS        \
             --target=$LFS_TGT          \
             --disable-nls              \
             --disable-werror && \
make           && \
make install   && \
popd           && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done binutils.sh +++\n\n"
