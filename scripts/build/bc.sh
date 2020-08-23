#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start bc.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".bc"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/bc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
PREFIX=/usr CC=gcc CFLAGS="-std=c99" ./configure.sh -G -O3                 && \
make                                  && \
make test                             && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done bc.sh +++\n\n"
