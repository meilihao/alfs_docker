#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start procps-ng.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".procps-ng"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/procps-ng-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr                            \
            --exec-prefix=                           \
            --libdir=/usr/lib                        \
            --docdir=/usr/share/doc/procps-ng-3.3.16 \
            --disable-static                         \
            --disable-kill                           \
            --with-systemd            && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-procps-ng-`date +%s`.log
fi                                    && \
make install                          && \
# mv -v /usr/lib/libprocps.so.* /lib    && \
# ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done procps-ng.sh +++\n\n"
