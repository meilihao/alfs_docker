#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start expat.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".expat"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/expat-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/expat-2.2.10 && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-expat-`date +%s`.log
fi                                    && \
make install                          && \
if [ $LFS_DOCS -eq 1 ]; then
    install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.10
fi                                    && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done expat.sh +++\n\n"
