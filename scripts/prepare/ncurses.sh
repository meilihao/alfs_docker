#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start ncurses.sh +++\n\n"

LFS_Sources_Root=/lfs/sources
BuildDir=`mktemp -d --suffix ".ncurses"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/ncurses-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i s/mawk// configure && \
mkdir build               && \
pushd build               && \
  ../configure            && \
  make -C include         && \
  make -C progs tic       && \
popd                      && \
./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-debug              \
            --without-ada                \
            --without-normal             \
            --enable-widec            && \
make           && \
make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install   && \
echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so       && \
mv -v $LFS/usr/lib/libncursesw.so.6* $LFS/lib               && \
ln -sfv ../../lib/$(readlink $LFS/usr/lib/libncursesw.so) $LFS/usr/lib/libncursesw.so && \
popd           && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done ncurses.sh +++\n\n"
