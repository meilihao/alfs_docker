#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start ncurses.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".ncurses"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/ncurses-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in && \
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec            && \
make                                  && \
make install                          && \
# mv -v /usr/lib/libncursesw.so.6* /lib                                         && \
# ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so && \
for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done
rm -vf                     /usr/lib/libcursesw.so && \
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so && \
ln -sfv libncurses.so      /usr/lib/libcurses.so  && \
if [ $LFS_DOCS -eq 1 ]; then
    mkdir -v       /usr/share/doc/ncurses-6.2     && \
    cp -v -R doc/* /usr/share/doc/ncurses-6.2
fi                                                && \
popd                                              && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done ncurses.sh +++\n\n"
