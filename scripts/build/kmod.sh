#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start kmod.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".kmod"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/kmod-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr          \
            --bindir=/bin          \
            --sysconfdir=/etc      \
            --with-rootlibdir=/lib \
            --with-xz              \
            --with-zlib               && \
make                                  && \
make install

for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /sbin/$target
done

ln -sfv kmod /bin/lsmod               && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done kmod.sh +++\n\n"
