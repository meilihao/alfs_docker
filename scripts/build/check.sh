#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start check.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".check"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/check-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --disable-static && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1 | tee /logs/test-check-`date +%s`.log
fi                                    && \
make docdir=/usr/share/doc/check-0.15.2 install && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done check.sh +++\n\n"
