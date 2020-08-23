#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start libelf.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".libelf"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/elfutils-*.tar.bz2 -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --disable-debuginfod --libdir=/lib && \
make                                  && \
make check                            && \
make -C libelf install                && \
install -vm644 config/libelf.pc /usr/lib/pkgconfig && \
rm /lib/libelf.a                      && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done libelf.sh +++\n\n"
