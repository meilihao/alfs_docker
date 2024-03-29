#!/usr/bin/env bash
set -e

# 8.73. Util-linux-2.36

echo -e "\n\n+++ start util-linux2.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".util-linux2"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/util-linux-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
mkdir -pv /var/lib/hwclock && \
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
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
if [ $LFS_TEST -eq 1 ]; then
    chown -Rv tester .                    && \
    su tester -c "make -k check 2>&1| tee /logs/test-util-linux2-`date +%s`.log"
fi                                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done util-linux2.sh +++\n\n"
