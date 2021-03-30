#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start autoconf.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".autoconf"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/autoconf-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr             && \
make                                  && \
# make check || true                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done autoconf.sh +++\n\n"
