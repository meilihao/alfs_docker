#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start patch.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".patch"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/patch-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr             && \
make                                  && \
make check                            && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done patch.sh +++\n\n"
