#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start sed.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".sed"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/sed-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --bindir=/bin && \
make                                  && \
make html                             && \
if [ $LFS_TEST -eq 1 ]; then
    chown -Rv tester .                && \
    su tester -c "PATH=$PATH make check 2>&1| tee /logs/test-sed-`date +%s`.log"
fi                                    && \
make install                          && \
if [ $LFS_DOCS -eq 1 ]; then
    install -d -m755           /usr/share/doc/sed-4.8 && \
    install -m644 doc/sed.html /usr/share/doc/sed-4.8
fi                                    && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done sed.sh +++\n\n"
