#!/usr/bin/env bash
set -e

# ./configure get error:
# configure: error: Package requirements (libsystemd) were not met:
# No package 'libsystemd' found
# ----
# pkg-config --exists --print-errors "systemd" is ok, pkg-config --exists --print-errors "libsystemd" is bad, found /usr/share/pkgconfig/systemd.pc and /usr/lib64/pkgconfig/libsystemd.pc with new fs layout.
# `pkg-config --variable pc_path pkg-config` get `/usr/lib/pkgconfig:/usr/share/pkgconfig`, no "/usr/lib64/pkgconfig". fix in pkg-config.sh

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
