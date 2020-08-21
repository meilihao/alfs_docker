#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gcc.sh +++\n\n"

LFS_Sources_Root=${LFSRoot}/sources
BuildDir=`mktemp -d --suffix ".gcc"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/gcc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
mkdir -pv ${BuildDir}/mpfr &&  tar -xf ${LFS_Sources_Root}/mpfr-*.tar.xz -C ${BuildDir}/mpfr --strip-components 1 && \
mkdir -pv ${BuildDir}/gmp &&  tar -xf ${LFS_Sources_Root}/gmp-*.tar.xz -C ${BuildDir}/gmp --strip-components 1 && \
mkdir -pv ${BuildDir}/mpc &&  tar -xf ${LFS_Sources_Root}/mpc-*.tar.gz -C ${BuildDir}/mpc --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64 && \
mkdir -v build && \
cd build       && \
../configure                                       \
    --target=$LFS_TGT                              \
    --prefix=$LFS/tools                            \
    --with-glibc-version=2.28                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --enable-initfini-array                        \
    --disable-nls                                  \
    --disable-shared                               \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++
make           && \
make install   && \
cd ..          && \
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h && \
popd           && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done gcc.sh +++\n\n"
