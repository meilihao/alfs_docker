#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start libcap.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".libcap"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/libcap-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i '/install -m.*STACAPLIBNAME/d' libcap/Makefile                          && \
make lib=lib                          && \
if [ $LFS_TEST -eq 1 ]; then
    make test
fi                                    && \
make lib=lib PKGCONFIGDIR=/usr/lib/pkgconfig install                           && \
chmod -v 755 /lib/libcap.so.2.42      && \
mv -v /lib/libpsx.a /usr/lib          && \
rm -v /lib/libcap.so                  && \
ln -sfv ../../lib/libcap.so.2 /usr/lib/libcap.so                               && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done libcap.sh +++\n\n"
