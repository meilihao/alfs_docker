#!/usr/bin/env bash
set -e

# failed is ok: 223: capabilities: binary store/restore              FAILED (capabs_raw01.at:28)

echo -e "\n\n+++ start tar.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".tar"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/tar-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
            --bindir=/bin             && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-tar-`date +%s`.log
fi                                    && \
make install                          && \
make -C doc install-html docdir=/usr/share/doc/tar-1.34 && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done tar.sh +++\n\n"
