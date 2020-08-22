#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start dejagnu.sh +++\n\n"

LFS_Sources_Root=${LFSRoot}/sources
BuildDir=`mktemp -d --suffix ".dejagnu"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/dejagnu-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr  && \
makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi && \
makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi && \
make install                          && \
install -v -dm755  /usr/share/doc/dejagnu-1.6.2                 && \
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.2 && \
make check                            && \
popd                                  && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done dejagnu.sh +++\n\n"
