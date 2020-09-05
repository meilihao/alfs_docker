#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start man-pages.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".man-pages"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/man-pages-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done man-pages.sh +++\n\n"
