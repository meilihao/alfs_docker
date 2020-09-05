#!/usr/bin/env bash
set -e
echo -e "--- start run-build-in-chroot.sh in chroot ---\n\n"

${LFSRoot}/scripts/build/create-directories.sh
${LFSRoot}/scripts/build/creating-essential-files-and-symlinks.sh

echo -e "--- done run-build-in-chroot.sh in chroot ---\n\n"

echo -e "--- exit chroot ---\n\n"

exit