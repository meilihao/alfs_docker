#!/usr/bin/env bash
set -e

# TODO
# test get error???:
# 1. FAIL tests/misc/chroot-credentials.sh (exit status: 1)
# look report to found test log(tests/test-suite.log)
# cat test-suite.log
# ++ chroot --userspec=tester:101 / whoami
# + whoami_after_chroot=tester
# + test tester '!=' root
# ++ chroot --userspec=:101 / id -G
# ++ id -G
# + test 101 = '101 0'
# + fail=1
# cat tests/misc/chroot-credentials.sh
# ...
# # Verify that credentials are changed correctly.
# whoami_after_chroot=$(
#   chroot --userspec=$NON_ROOT_USERNAME:$NON_ROOT_GROUP / whoami
# )
# test "$whoami_after_chroot" != "$root" || fail=1

# # Verify that when specifying only a group we don't change the
# # list of supplemental groups
# test "$(chroot --userspec=:$NON_ROOT_GROUP / id -G)" = \
#      "$NON_ROOT_GID $(id -G)" || fail=1
# ...
# # chroot --userspec=:101 / strace /tmp/tmp.RPNjtKhtUc.coreutils/src/id -G # in docker's chroot
# ...
# getuid()                                = 0
# getegid()                               = 101
# getgid()                                = 101
# fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x3), ...}) = 0
# getgroups(0, NULL)                      = 0
# getgroups(0, [])                        = 0
# write(1, "101\n", 4101
# )                    = 4
# ...
# # chroot --userspec=:101 / strace id -G # in dcoker
# ...
# getuid()                                = 0
# getegid()                               = 101
# getgid()                                = 101
# fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x4), ...}) = 0
# getgroups(0, NULL)                      = 0
# getgroups(0, [])                        = 0
# write(1, "101\n", 4101
# )                    = 4
# ...
# # chroot --userspec=:101 / strace id -G # in host
# ...
# getuid()                                = 0
# getegid()                               = 101
# getgid()                                = 101
# fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(0x88, 0x3), ...}) = 0
# getgroups(0, NULL)                      = 1
# getgroups(1, [0])                       = 1
# write(1, "101 0\n", 6101 0
# )                  = 6
# ...
# > getgroups() 用来取得目前用户所属的附加组（supplementary group） ids. 参数size 为list() 所能容纳的gid_t 数目. 如果参数size 值为零, 此函数仅会返回用户所属的组数.
# 推测是使用docker而引发该错误, 待qemu启动image时再测.
# --- other error
# make check TESTS=tests/tail-2/inotify-dir-recreate KEEP=yes VERBOSE=yes
# see [LFS in docker. Preparation: coreutils check fails.](https://dnsglk.github.io/lfs/2018/06/28/lfs-coreutils-test-issue.html) , use docker volume to avoid it because A volume is a specially-designated directory within one or more containers that bypasses the Union File System. tested.


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
    make NON_ROOT_USERNAME=tester check-root 2>&1 | tee /logs/test-coreutils-`date +%s`-root.log || true && \
    echo "dummy:x:102:tester" >> /etc/group  && \
    chown -Rv tester .                       && \
    su tester -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check 2>&1 | tee -a /logs/test-coreutils-`date +%s`-tester.log" || true && \
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
