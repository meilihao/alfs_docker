#!/usr/bin/env bash
set -e
echo -e "--- start run-build-in-chroot-again in chroot ---\n\n"

LFS_Script_Build=${LFSRoot}/scripts/build

${LFS_Script_Build}/man-pages.sh
${LFS_Script_Build}/tcl.sh
${LFS_Script_Build}/expect.sh
${LFS_Script_Build}/dejagun.sh

unset LFS_Script_Build

echo -e "--- done run-build-in-chroot-again in chroot ---\n\n"

echo -e "--- exit chroot again ---\n\n"

exit