#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start attr.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".attr"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/attr-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.4.48                              && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1 | tee /logs/test-attr-`date +%s`.log
fi                                    && \
make install                          && \
mv -v /usr/lib/libattr.so.* /lib      && \
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so        && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done attr.sh +++\n\n"
