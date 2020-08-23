#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start tar.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".tar"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/tar-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin             && \
make                                  && \
make check                            && \
make install                          && \
make -C doc install-html docdir=/usr/share/doc/tar-1.32 && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done tar.sh +++\n\n"
