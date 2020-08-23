#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gperf.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".gperf"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gperf-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.1                   && \
make                                  && \
make -j1 check                        && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done gperf.sh +++\n\n"
