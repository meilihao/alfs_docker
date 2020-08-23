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
make check                            && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done libffi.sh +++\n\n"
