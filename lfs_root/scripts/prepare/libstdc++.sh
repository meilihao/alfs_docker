#!/usr/bin/env bash
set -e

# now no path: /tools

echo -e "\n\n+++ start libstdc++.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".libstdc++"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gcc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
mkdir -v build && \
cd       build && \
../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/10.2.0 && \
make                                  && \
make DESTDIR=$LFS install             && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done libstdc++.sh +++\n\n"
