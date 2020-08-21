#!/usr/bin/env bash
set -e
echo "--- start run-build.sh in chroot ---"

LFS_Script_Build=/lfs/scripts/build

${LFS_Script_Build}/create-directories.sh

unset LFS_Script_Build

echo -e "--- done run-build.sh in chroot ---\n\n"
