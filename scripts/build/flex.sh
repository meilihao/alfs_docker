#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start flex.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".flex"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/flex-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.4                 && \
make                                  && \
make check                            && \
make install                          && \
ln -sv flex /usr/bin/lex              && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done flex.sh +++\n\n"
