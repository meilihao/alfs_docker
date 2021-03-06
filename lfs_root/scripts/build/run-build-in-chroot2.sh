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

if [[ `ls -l -A /tmp |grep "^d"|grep "tmp." |wc -l` -gt 0 ]]; then
     read
fi

# clean for backup
${LFSRoot}/scripts/build/cleanup.sh

echo -e "--- done run-build-in-chroot2.sh in chroot ---\n\n"
