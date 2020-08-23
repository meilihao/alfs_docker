#!/usr/bin/env bash
set -e
echo -e "--- start run-build-in-chroot2.sh in chroot ---\n\n"

${LFSRoot}/scripts/build/creating-essential-files-and-symlinks2.sh
${LFSRoot}/scripts/build/libstdc++.sh
${LFSRoot}/scripts/build/gettext.sh
${LFSRoot}/scripts/build/bison.sh
${LFSRoot}/scripts/build/perl.sh
${LFSRoot}/scripts/build/python.sh
${LFSRoot}/scripts/build/texinfo.sh
${LFSRoot}/scripts/build/util-linux.sh
${LFSRoot}/scripts/build/cleanup.sh

echo -e "--- done run-build-in-chroot2.sh in chroot ---\n\n"
