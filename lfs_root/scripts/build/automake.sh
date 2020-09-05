#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start automake.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".automake"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/automake-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i "s/''/etags/" t/tags-lisp-space.sh && \
./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.16.2 && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make -j4 check 2>&1 | tee /logs/test-automake-`date +%s`.log
fi                                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done automake.sh +++\n\n"
