#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start less.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".less"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/less-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --sysconfdir=/etc && \
make                                  && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done less.sh +++\n\n"
