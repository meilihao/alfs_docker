#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gawk.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".gawk"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gawk-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i 's/extras//' Makefile.in       && \
./configure --prefix=/usr             && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-gawk-`date +%s`.log
fi                                    && \
make install                          && \
if [ $LFS_DOCS -eq 1 ]; then
    mkdir -v /usr/share/doc/gawk-5.1.0 && \
    cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-5.1.0
fi                                    && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done gawk.sh +++\n\n"
