#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start acl.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".acl"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/acl-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/acl-2.2.53                              && \
make                                  && \
make install                          && \
mv -v /usr/lib/libacl.so.* /lib       && \
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so         && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done acl.sh +++\n\n"
