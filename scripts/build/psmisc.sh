#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start psmisc.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".psmisc"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/psmisc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr             && \
make                                  && \
make install                          && \
mv -v /usr/bin/fuser   /bin           && \
mv -v /usr/bin/killall /bin           && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done psmisc.sh +++\n\n"
