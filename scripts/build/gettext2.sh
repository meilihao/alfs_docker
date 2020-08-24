#!/usr/bin/env bash
set -e

# 8.31. Gettext-0.21

echo -e "\n\n+++ start gettext2.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".gettext2"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gettext-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/gettext-0.21 && \
make                                  && \
make check                            && \
make install                          && \
chmod -v 0755 /usr/lib/preloadable_libintl.so    && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done gettext2.sh +++\n\n"
