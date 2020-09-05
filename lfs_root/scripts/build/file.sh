#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start file.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".file"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/file-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr             && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-file-`date +%s`.log
fi                                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done file.sh +++\n\n"
