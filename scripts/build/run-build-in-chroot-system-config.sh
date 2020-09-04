#!/usr/bin/env bash
set -e
echo -e "--- start run-build-in-chroot-system-config.sh in chroot ---\n\n"

${LFSRoot}/scripts/build/system-config.sh
${LFSRoot}/scripts/build/cpio.sh
${LFSRoot}/scripts/build/lz4.sh
${LFSRoot}/scripts/build/kernel.sh
${LFSRoot}/scripts/build/the-end.sh

if [[ `ls -l -A /tmp |grep "^d"|grep "tmp." |wc -l` -gt 0 ]]; then
     read
fi

${LFSRoot}/scripts/build/cleanup2.sh

echo -e "--- done run-build-in-chroot-system-config.sh in chroot ---\n\n"
