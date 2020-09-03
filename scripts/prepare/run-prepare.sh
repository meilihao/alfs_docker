#!/usr/bin/env bash
set -e
set -x

# The cross-compiler will be installed in a separate $LFS/tools directory, since it will not be part of the final system. 

echo "--- start run-prepare.sh ---"

${LFSRoot}/scripts/prepare/binutils.sh
${LFSRoot}/scripts/prepare/gcc.sh
${LFSRoot}/scripts/prepare/linux-api-header.sh
${LFSRoot}/scripts/prepare/glibc.sh
${LFSRoot}/scripts/prepare/libstdc++.sh
${LFSRoot}/scripts/prepare/m4.sh
${LFSRoot}/scripts/prepare/ncurses.sh
${LFSRoot}/scripts/prepare/bash.sh
${LFSRoot}/scripts/prepare/coreutils.sh
${LFSRoot}/scripts/prepare/diffutils.sh
${LFSRoot}/scripts/prepare/file.sh
${LFSRoot}/scripts/prepare/findutils.sh
${LFSRoot}/scripts/prepare/gawk.sh
${LFSRoot}/scripts/prepare/grep.sh
${LFSRoot}/scripts/prepare/gzip.sh
${LFSRoot}/scripts/prepare/make.sh
${LFSRoot}/scripts/prepare/patch.sh
${LFSRoot}/scripts/prepare/sed.sh
${LFSRoot}/scripts/prepare/tar.sh
${LFSRoot}/scripts/prepare/xz.sh
${LFSRoot}/scripts/prepare/binutils2.sh
${LFSRoot}/scripts/prepare/gcc2.sh

if [[ `ll -A /tmp |grep "^d"|wc -l` -gt 0 ]]; then
     read
fi

echo -e "--- done run-prepare.sh ---\n\n"
