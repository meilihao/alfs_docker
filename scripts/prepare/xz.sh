#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start xz.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".xz"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/xz-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.2.5 && \
make           && \
make DESTDIR=$LFS install                 && \
mv -v $LFS/usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat}  $LFS/bin                && \
mv -v $LFS/usr/lib/liblzma.so.*                       $LFS/lib                && \
ln -svf ../../lib/$(readlink $LFS/usr/lib/liblzma.so) $LFS/usr/lib/liblzma.so && \
popd           && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done xz.sh +++\n\n"
