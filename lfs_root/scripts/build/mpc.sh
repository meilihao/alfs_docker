#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start mpc.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".mpc"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/mpc-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.2.1                               && \
make                                  && \
make html                             && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-mpc-`date +%s`.log
fi                                    && \
make install                          && \
make install-html                     && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done mpc.sh +++\n\n"
