#!/usr/bin/env bash
set -e
echo -e "--- start run-build2.sh in chroot ---\n\n"

LFS_Script_Build=${LFSRoot}/scripts/build

${LFS_Script_Build}/creating-essential-files-and-symlinks2.sh
${LFS_Script_Build}/libstdc++.sh
${LFS_Script_Build}/gettext.sh
${LFS_Script_Build}/bison.sh
${LFS_Script_Build}/perl.sh
${LFS_Script_Build}/python.sh
${LFS_Script_Build}/texinfo.sh
${LFS_Script_Build}/util-linux.sh
${LFS_Script_Build}/cleanup.sh

unset LFS_Script_Build

echo -e "--- done run-build2.sh in chroot ---\n\n"
