#!/usr/bin/env bash
# 已知一项名为 VERSION 的测试可能失败

set -e

echo -e "\n\n+++ start gdbm.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".gdbm"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gdbm-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat   && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-gdbm-`date +%s`.log
fi                                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done gdbm.sh +++\n\n"
