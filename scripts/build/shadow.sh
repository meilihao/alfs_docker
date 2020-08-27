#!/usr/bin/env bash
set -e
echo -e "\n\n+++ start shadow.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".shadow"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/shadow-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i 's/groups$(EXEEXT) //' src/Makefile.in                                  && \
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;              && \
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;              && \
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;              && \
sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD SHA512:' \
    -e 's:/var/spool/mail:/var/mail:'                 \
    -i etc/login.defs                 && \
sed -i 's/1000/999/' etc/useradd      && \
touch /usr/bin/passwd                 && \
./configure --sysconfdir=/etc \
            --with-group-name-max-length=32 && \
make                                  && \
make install                          && \
pwconv                                && \
grpconv                               && \
echo "root:root" | chpasswd           && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done shadow.sh +++\n\n"
