#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start bash.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".bash"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/bash-*.tar.gz -C ${BuildDir} --strip-components 1 && \
chmod 755 ${BuildDir} && \
pushd ${PWD}   && \
cd ${BuildDir} && \
patch -Np1 -i ${LFSRoot}/sources/bash-5.0-upstream_fixes-1.patch             && \
./configure --prefix=/usr                    \
            --docdir=/usr/share/doc/bash-5.0 \
            --without-bash-malloc            \
            --with-installed-readline && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    getfacl -R -p $(tty) > ${BuildDir}/permissions.facl && \
    chmod a+rw $(tty)                            && \
    chown -Rv tester .                           && \
    su tester << EOF | tee /logs/test-bash-`date +%s`.log
PATH=$PATH make tests < $(tty)
EOF
    setfacl --restore=${BuildDir}/permissions.facl
fi                                    && \
make install                          && \
# mv -vf /usr/bin/bash /bin             && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done bash.sh +++\n\n"