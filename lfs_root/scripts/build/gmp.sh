#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gmp.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".gmp"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gmp-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.2.1                             && \
make                                  && \
make html                             && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1 | tee gmp-check-log && \
    awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log  | grep "197"
fi                                    && \
make install                          && \
make install-html                     && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done gmp.sh +++\n\n"
