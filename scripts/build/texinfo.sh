#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start texinfo.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".texinfo"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/texinfo-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr             && \
make                                  && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done texinfo.sh +++\n\n"
