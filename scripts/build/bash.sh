#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start bash.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".bash"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/bash-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
patch -Np1 -i ${LFSRoot}/sources/bash-5.0-upstream_fixes-1.patch             && \
./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-5.0 \
            --without-bash-malloc            \
            --with-installed-readline && \
make                                  && \
chown -Rv tester .                    && \
su tester << EOF                      && \
PATH=$PATH make tests < $(tty)
EOF
make install                          && \
mv -vf /usr/bin/bash /bin             && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done bash.sh +++\n\n"
