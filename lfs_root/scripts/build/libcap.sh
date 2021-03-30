#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start libcap.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".libcap"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/libcap-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i '/install -m.*STA/d' libcap/Makefile                          && \
make prefix=/usr lib=lib                          && \
if [ $LFS_TEST -eq 1 ]; then
    make test 2>&1| tee /logs/test-libcap-`date +%s`.log
fi                                    && \
make prefix=/usr lib=lib install      && \
# mv -v /usr/lib/libcap.so.* /lib          && \
# mv -v /usr/lib/libpsx.so.* /lib          && \
# ln -sfv ../../lib/libcap.so.2 /usr/lib/libcap.so                               && \
# ln -sfv ../../lib/libpsx.so.2 /usr/lib/libpsx.so                               && \
chmod -v 755 /lib/libcap.so.2.48      && \
chmod -v 755 /lib/libpsx.so.2.48      && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done libcap.sh +++\n\n"
