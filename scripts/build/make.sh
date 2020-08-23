#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start make.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".make"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/make-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr             && \
make                                  && \
make check                            && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done make.sh +++\n\n"
