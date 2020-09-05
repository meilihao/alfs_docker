#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start man-db.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".man-db"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/man-db-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i '/find/s@/usr@@' init/systemd/man-db.service.in && \
./configure --prefix=/usr                        \
            --docdir=/usr/share/doc/man-db-2.9.3 \
            --sysconfdir=/etc                    \
            --disable-setuid                     \
            --enable-cache-owner=bin             \
            --with-browser=/usr/bin/lynx         \
            --with-vgrind=/usr/bin/vgrind        \
            --with-grap=/usr/bin/grap && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-man-db-`date +%s`.log
fi                                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done man-db.sh +++\n\n"
