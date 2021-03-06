#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start libffi.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".libffi"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/libffi-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --disable-static --with-gcc-arch=native && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-libffi-`date +%s`.log
fi                                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done libffi.sh +++\n\n"
