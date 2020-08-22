#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start coreutils.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".coreutils"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/coreutils-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --enable-install-program=hostname \
            --enable-no-install-program=kill,uptime && \
make           && \
make DESTDIR=$LFS install && \
mv -v $LFS/usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} $LFS/bin                          && \
mv -v $LFS/usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm}        $LFS/bin                          && \
mv -v $LFS/usr/bin/{rmdir,stty,sync,true,uname}               $LFS/bin                          && \
mv -v $LFS/usr/bin/{head,nice,sleep,touch}                    $LFS/bin                          && \
mv -v $LFS/usr/bin/chroot                                     $LFS/usr/sbin                     && \
mkdir -pv $LFS/usr/share/man/man8                                                               && \
mv -v $LFS/usr/share/man/man1/chroot.1                        $LFS/usr/share/man/man8/chroot.8  && \
sed -i 's/"1"/"8"/'                                           $LFS/usr/share/man/man8/chroot.8  && \
popd           && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done coreutils.sh +++\n\n"
