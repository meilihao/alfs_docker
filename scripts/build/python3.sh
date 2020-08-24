#!/usr/bin/env bash
set -e

# 8.49. Python-3.8.5

echo -e "\n\n+++ start python3.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".python3"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/Python-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr       \
            --enable-shared     \
            --with-system-expat \
            --with-system-ffi   \
            --with-ensurepip=yes      && \
make                                  && \
make install                          && \
chmod -v 755 /usr/lib/libpython3.8.so              && \
chmod -v 755 /usr/lib/libpython3.so                && \
ln -sfv pip3.8 /usr/bin/pip3                       && \
if [ $LFS_DOCS -eq 1 ]; then
    install -v -dm755 /usr/share/doc/python-3.8.5/html && \
    tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/python-3.8.5/html \
    -xvf ${LFSRoot}/python-3.8.5-docs-html.tar.bz2
fi                                    && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done python3.sh +++\n\n"
