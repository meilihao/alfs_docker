#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start util-linux.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".util-linux"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/util-linux-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
mkdir -pv /var/lib/hwclock            && \
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
            --docdir=/usr/share/doc/util-linux-2.36.2 \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            runstatedir=/run          && \
make                                  && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done util-linux.sh +++\n\n"
