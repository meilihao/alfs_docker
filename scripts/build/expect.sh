#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start expect.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".expect"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/expect*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make test
fi                                    && \
make install                          && \
ln -svf expect5.45.4/libexpect5.45.4.so /usr/lib  && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done expect.sh +++\n\n"
