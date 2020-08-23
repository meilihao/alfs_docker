#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start intltool.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".intltool"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/intltool-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i 's:\\\${:\\\$\\{:' intltool-update.in && \
./configure --prefix=/usr             && \
make                                  && \
make check                            && \
make install                          && \
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done intltool.sh +++\n\n"
