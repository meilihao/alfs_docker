#!/usr/bin/env bash
set -e
echo -e "--- start run-build.sh in chroot ---\n\n"

LFS_Script_Build=${LFSRoot}/scripts/build

${LFS_Script_Build}/create-directories.sh
${LFS_Script_Build}/creating-essential-files-and-symlinks.sh

unset LFS_Script_Build

echo -e "--- done run-build.sh in chroot ---\n\n"

echo -e "--- exit chroot ---\n\n"

exit