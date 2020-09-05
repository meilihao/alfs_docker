#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start iana-etc.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".iana-etc"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/iana-etc-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
cp services protocols /etc            && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done iana-etc.sh +++\n\n"
