#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start pkg-config.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".pkg-config"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/pkg-config-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2  && \
make                                  && \
make check                            && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done pkg-config.sh +++\n\n"
