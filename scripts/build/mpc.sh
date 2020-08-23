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
            --docdir=/usr/share/doc/mpc-1.1.0                               && \
make                                  && \
make html                             && \
make check                            && \
make install                          && \
make install-html                     && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done mpc.sh +++\n\n"
