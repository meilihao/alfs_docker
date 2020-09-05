#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start coreutils.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".coreutils"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/coreutils-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
patch -Np1 -i ${LFSRoot}/sources/coreutils-8.32-i18n-1.patch && \
sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk    && \
autoreconf -fiv && \
FORCE_UNSAFE_CONFIGURE=1 ./configure \
            --prefix=/usr            \
            --enable-no-install-program=kill,uptime  && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make NON_ROOT_USERNAME=tester check-root 2>&1 | tee /logs/test-coreutils-`date +%s`.log && \
    echo "dummy:x:102:tester" >> /etc/group  && \
    chown -Rv tester .                       && \
    su tester -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check 2>&1 | tee -a /logs/test-coreutils-`date +%s`.log" && \
    sed -i '/dummy/d' /etc/group
fi                                    && \
make install                          && \
# mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin   && \
# mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin          && \
# mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin                 && \
mv -v /usr/bin/chroot /usr/sbin                                  && \
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8  && \
sed -i 's/"1"/"8"/' /usr/share/man/man8/chroot.8                 && \
# mv -v /usr/bin/{head,nice,sleep,touch} /bin                      && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done coreutils.sh +++\n\n"
