#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start groff.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".groff"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/groff-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
PAGE=<paper_size> ./configure --prefix=/usr && \
make -j1                              && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done groff.sh +++\n\n"
