#!/usr/bin/env bash
set -e

# 8.32. Bison-3.7.1

echo -e "\n\n+++ start bison2.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".bison2"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/bison-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.7.1 && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check
fi                                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done bison2.sh +++\n\n"
