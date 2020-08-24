#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start inetutils.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".inetutils"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/inetutils-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr        \
            --localstatedir=/var \
            --disable-logger     \
            --disable-whois      \
            --disable-rcp        \
            --disable-rexec      \
            --disable-rlogin     \
            --disable-rsh        \
            --disable-servers         && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check
fi                                    && \
make install                          && \
mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin && \
mv -v /usr/bin/ifconfig /sbin         && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done inetutils.sh +++\n\n"
