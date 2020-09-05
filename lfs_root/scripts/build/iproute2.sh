#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start iproute2.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".iproute2"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/iproute2-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i /ARPD/d Makefile               && \
rm -fv man/man8/arpd.8                && \
sed -i 's/.m_ipt.o//' tc/Makefile     && \
make                                  && \
make DOCDIR=/usr/share/doc/iproute2-5.8.0 install && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done iproute2.sh +++\n\n"
