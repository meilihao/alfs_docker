#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start kbd.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".kbd"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/kbd-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
patch -Np1 -i ${LFSRoot}/sources/kbd-2.3.0-backspace-1.patch && \
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure      && \
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in && \
./configure --prefix=/usr --disable-vlock            && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-kbd-`date +%s`.log
fi                                    && \
make install                          && \
rm -v /usr/lib/libtswrap.{a,la,so*}   && \
mkdir -v            /usr/share/doc/kbd-2.3.0 && \
cp -R -v docs/doc/* /usr/share/doc/kbd-2.3.0 && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done kbd.sh +++\n\n"
