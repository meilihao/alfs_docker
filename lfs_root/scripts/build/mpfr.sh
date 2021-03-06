#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start mpfr.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".mpfr"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/mpfr-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.1.0                              && \
make                                  && \
make html                             && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-mpfr-`date +%s`.log
fi                                    && \
make install                          && \
make install-html                     && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done mpfr.sh +++\n\n"
