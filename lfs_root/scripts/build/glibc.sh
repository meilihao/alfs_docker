#!/usr/bin/env bash
set -e

# install the locale for your own country, language and character set.
# cp ld-linux-x86-64.so.2 is because ${BuildDir} will be deleted.
# build /usr/lib/locale before run `make check`, otherwise will meet "cannot create temporary file: /usr/lib/locale/locale-archive.F0yCs6: No such file or directory"
#
# `make check` will failed and throw error:
# - `FAIL: io/tst-lchmod`
# - `misc/tst-ttyname `
# so ignore this errors.
# must mount something in prepare-vkfs-again.sh, otherwise your will get more FAILs with `FAIL: io/tst-lchmod`, like ""

echo -e "\n\n+++ start glibc.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".glibc"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/glibc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
patch -Np1 -i ${LFSRoot}/sources/glibc-2.33-fhs-1.patch                 && \
sed -e '402a\      *result = local->data.services[database_index];' \
    -i nss/nss_database.c                                               && \
mkdir -v build && \
cd       build && \
../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=4.19                     \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/lib     && \
make                                  && \
# cp -f $PWD/elf/ld-linux-x86-64.so.2 /lib/elf_ld-linux-x86-64.so.2        && \
# ln -sfnv elf_ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2              && \
# ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 /lib && \
mkdir -pv /usr/lib/locale             && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-glibc-`date +%s`.log || true
fi                                    && \
rm -rf /usr/lib/locale                && \
touch /etc/ld.so.conf                 && \
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile      && \
make install                          && \
cp -v ../nscd/nscd.conf /etc/nscd.conf && \
mkdir -pv /var/cache/nscd             && \
install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf    && \
install -v -Dm644 ../nscd/nscd.service /lib/systemd/system/nscd.service  && \
touch /etc/netgroup                                                      && \
mkdir -pv /usr/lib/locale                                                && \
localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true                 && \
localedef -i en_US -f UTF-8 en_US.UTF-8                                  && \
localedef -i zh_CN -f UTF-8 zh_CN.UTF-8                                  && \
# make localedata/install-locales                                        && \
popd                                                                     && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done glibc.sh +++\n\n"
