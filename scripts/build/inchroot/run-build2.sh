#!/usr/bin/env bash
set -e
echo -e "--- start run-build2.sh in chroot ---\n\n"

LFS_Script_Build=/lfs/scripts/build

${LFS_Script_Build}/creating-essential-files-and-symlinks2.sh
${LFS_Script_Build}/libstdc++.sh

unset LFS_Script_Build

echo -e "--- done run-build2.sh in chroot ---\n\n"
