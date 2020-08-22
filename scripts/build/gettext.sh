#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gettext.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".gettext"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gettext-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --disable-shared          && \
make                                  && \
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin                      && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done gettext.sh +++\n\n"
