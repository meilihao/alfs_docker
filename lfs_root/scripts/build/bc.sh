#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start bc.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".bc"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/bc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
PREFIX=/usr CC=gcc ./configure.sh -G -O3                 && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make test 2>&1 | tee /logs/test-bc-`date +%s`.log
fi                                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done bc.sh +++\n\n"
