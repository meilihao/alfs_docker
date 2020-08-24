#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start xz.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".xz"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/xz-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/xz-5.2.5 && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check
fi                                    && \
make install                          && \
mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin                    && \
mv -v /usr/lib/liblzma.so.* /lib                                           && \
ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so      && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done xz.sh +++\n\n"
