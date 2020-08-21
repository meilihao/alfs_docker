#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gettext.sh +++\n\n"

LFS_Sources_Root=${LFSRoot}/sources
BuildDir=`mktemp -d --suffix ".gettext"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/gettext-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --disable-shared          && \
make                                  && \
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin                      && \
popd                                  && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done gettext.sh +++\n\n"
