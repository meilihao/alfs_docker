#!/usr/bin/env bash
set -e

# for build kernel

echo -e "\n\n+++ start lz4.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".lz4"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/lz4-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
make                                  && \
PREFIX=/usr make install              && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done lz4.sh +++\n\n"
