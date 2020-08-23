#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start findutils.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".findutils"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/findutils-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --localstatedir=/var/lib/locate && \
make                                  && \
chown -Rv tester .                    && \
su tester -c "PATH=$PATH make check"  && \
make install                          && \
mv -v /usr/bin/find /bin              && \
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done findutils.sh +++\n\n"
