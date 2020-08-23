#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start openssl.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".openssl"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/openssl-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic                 && \
make                                  && \
make test                             && \
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile   && \
make MANSUFFIX=ssl install            && \
mv -v /usr/share/doc/openssl /usr/share/doc/openssl-1.1.1g && \
cp -vfr doc/* /usr/share/doc/openssl-1.1.1g                && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done openssl.sh +++\n\n"
