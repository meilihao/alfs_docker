#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start findutils.sh +++\n\n"

LFS_Sources_Root=/lfs/sources
BuildDir=`mktemp -d --suffix ".findutils"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/findutils-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess) && \
make           && \
make DESTDIR=$LFS install                 && \
mv -v $LFS/usr/bin/find $LFS/bin          && \
sed -i 's|find:=${BINDIR}|find:=/bin|' $LFS/usr/bin/updatedb && \
popd           && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done findutils.sh +++\n\n"
