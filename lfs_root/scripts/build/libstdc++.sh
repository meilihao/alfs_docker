#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start libstdc++.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".libstdc++"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gcc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
ln -s gthr-posix.h libgcc/gthr-default.h && \
mkdir -v build && \
cd       build && \
../libstdc++-v3/configure            \
    CXXFLAGS="-g -O2 -D_GNU_SOURCE"  \
    --prefix=/usr                    \
    --disable-multilib               \
    --disable-nls                    \
    --host=$(uname -m)-lfs-linux-gnu \
    --disable-libstdcxx-pch
make                                  && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done libstdc++.sh +++\n\n"
