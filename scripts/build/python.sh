#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start python.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".python"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/Python-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip       && \
make                                  && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done python.sh +++\n\n"
