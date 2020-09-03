#!/usr/bin/env bash
set -e

# use `--with-pc-path` because libsystemd.pc in /usr/lib64/pkgconfig, and default pc path does not include /usr/lib64/pkgconfig

echo -e "\n\n+++ start pkg-config.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".pkg-config"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/pkg-config-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2 \
            --with-pc-path=/usr/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-pkg-config-`date +%s`.log
fi                                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done pkg-config.sh +++\n\n"
