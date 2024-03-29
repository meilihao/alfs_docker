#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start libelf.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".libelf"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/elfutils-*.tar.bz2 -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy \
            --libdir=/lib             && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-libelf-`date +%s`.log
fi                                    && \
make -C libelf install                && \
install -vm644 config/libelf.pc /usr/lib/pkgconfig && \
rm /lib/libelf.a                      && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done libelf.sh +++\n\n"
