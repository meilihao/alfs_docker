#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start dejagnu.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".dejagnu"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/dejagnu-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr  && \
makeinfo --html --no-split -o doc/dejagnu.html doc/dejagnu.texi && \
makeinfo --plaintext       -o doc/dejagnu.txt  doc/dejagnu.texi && \
make install                          && \
install -v -dm755  /usr/share/doc/dejagnu-1.6.2                 && \
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-1.6.2 && \
if [ $LFS_TEST -eq 1 ]; then
    make check
fi                                    && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done dejagnu.sh +++\n\n"
