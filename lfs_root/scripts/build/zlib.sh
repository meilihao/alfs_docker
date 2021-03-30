#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start zlib.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".zlib"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/zlib-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-zlib-`date +%s`.log
fi                                    && \
make install                          && \
# mv -v /usr/lib/libz.so.* /lib         && \
# ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so && \
rm -fv /usr/lib/libz.a                && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done zlib.sh +++\n\n"
