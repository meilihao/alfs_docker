#!/usr/bin/env bash
set -e

# install the locale for your own country, language and character set.

echo -e "\n\n+++ start glibc.sh +++\n\n"

LFS_Sources_Root=${LFSRoot}/sources
BuildDir=`mktemp -d --suffix ".glibc"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFS_Sources_Root}/glibc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
patch -Np1 -i ${LFS_Sources_Root}/glibc-2.32-fhs-1.patch                 && \
mkdir -v build && \
cd       build && \
../configure --prefix=/usr                            \
             --disable-werror                         \
             --enable-kernel=4.19                     \
             --enable-stack-protector=strong          \
             --with-headers=/usr/include              \
             libc_cv_slibdir=/lib     && \
make                                  && \
ln -sfnv $PWD/elf/ld-linux-x86-64.so.2 /lib && \
make check                            && \
touch /etc/ld.so.conf                 && \
sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile      && \
make install                          && \
cp -v ../nscd/nscd.conf /etc/nscd.conf &&\
mkdir -pv /var/cache/nscd             && \
install -v -Dm644 ../nscd/nscd.tmpfiles /usr/lib/tmpfiles.d/nscd.conf    && \
install -v -Dm644 ../nscd/nscd.service /lib/systemd/system/nscd.service  && \
mkdir -pv /usr/lib/locale                                                && \
localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true                 && \
localedef -i en_US -f UTF-8 en_US.UTF-8                                  && \
localedef -i zh_CN -f UTF-8 zh_CN.UTF-8                                  && \
# make localedata/install-locales                                        && \
popd                                                                     && \
rm -rf ${BuildDir}

unset LFS_Sources_Root
unset BuildDir

echo -e "+++ done glibc.sh +++\n\n"
