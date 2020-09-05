#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gzip.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".gzip"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gzip-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr             && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-gzip-`date +%s`.log
fi                                    && \
make install                          && \
# mv -v /usr/bin/gzip /bin              && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done gzip.sh +++\n\n"
