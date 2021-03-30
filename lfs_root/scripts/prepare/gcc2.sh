#!/usr/bin/env bash
set -e

# 6.18. GCC-10.2.0 - Pass 2 

echo -e "\n\n+++ start gcc2.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".gcc2"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gcc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
mkdir -pv ${BuildDir}/mpfr &&  tar -xf ${LFSRoot}/sources/mpfr-*.tar.xz -C ${BuildDir}/mpfr --strip-components 1 && \
mkdir -pv ${BuildDir}/gmp &&  tar -xf ${LFSRoot}/sources/gmp-*.tar.xz -C ${BuildDir}/gmp --strip-components 1 && \
mkdir -pv ${BuildDir}/mpc &&  tar -xf ${LFSRoot}/sources/mpc-*.tar.gz -C ${BuildDir}/mpc --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64     && \
mkdir -v build && \
cd build       && \
mkdir -pv $LFS_TGT/libgcc   && \
ln -s ../../../libgcc/gthr-posix.h $LFS_TGT/libgcc/gthr-default.h && \
../configure                                       \
    --build=$(../config.guess)                     \
    --host=$LFS_TGT                                \
    --prefix=/usr                                  \
    CC_FOR_TARGET=$LFS_TGT-gcc                     \
    --with-build-sysroot=$LFS                      \
    --enable-initfini-array                        \
    --disable-nls                                  \
    --disable-multilib                             \
    --disable-decimal-float                        \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++                    && \
make           && \
make DESTDIR=$LFS install  && \
ln -sv gcc $LFS/usr/bin/cc && \
popd           && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done gcc2.sh +++\n\n"
