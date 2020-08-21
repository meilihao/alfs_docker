#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start bison.sh +++\n\n"

LFS_Sources_Root=${LFSRoot}/sources
BuildDir=`mktemp -d --suffix ".bison"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/bison-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr \
            --docdir=/usr/share/doc/bison-3.7.1 && \
make                                  && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done bison.sh +++\n\n"
