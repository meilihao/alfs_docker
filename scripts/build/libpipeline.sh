#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start libpipeline.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".libpipeline"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/libpipeline-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr             && \
make                                  && \
make check                            && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done libpipeline.sh +++\n\n"
