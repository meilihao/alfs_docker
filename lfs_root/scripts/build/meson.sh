#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start meson.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".meson"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/meson-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
python3 setup.py build                && \
python3 setup.py install --root=dest  && \
cp -rv dest/* /                       && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done meson.sh +++\n\n"
