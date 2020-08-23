#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start zstd.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".zstd"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/zstd-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
make                                  && \
make prefix=/usr install              && \
rm -v /usr/lib/libzstd.a              && \
mv -v /usr/lib/libzstd.so.* /lib      && \
ln -sfv ../../lib/$(readlink /usr/lib/libzstd.so) /usr/lib/libzstd.so        && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done zstd.sh +++\n\n"
