#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start grub.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".grub"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/grub-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed "s/gold-version/& -R .note.gnu.property/" \
    -i Makefile.in grub-core/Makefile.in   && \
./configure --prefix=/usr          \
            --sbindir=/sbin        \
            --sysconfdir=/etc      \
            --disable-efiemu       \
            --with-platform=efi    \
            --disable-werror          && \
make                                  && \
make install                          && \
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions    && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done grub.sh +++\n\n"
