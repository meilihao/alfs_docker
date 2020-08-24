#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start m4.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".m4"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/m4-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c          && \
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h   && \
./configure --prefix=/usr             && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check
fi                                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done m4.sh +++\n\n"
