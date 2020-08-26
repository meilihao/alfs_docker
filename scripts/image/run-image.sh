#!/usr/bin/env bash
set -e
echo -e "--- start run-image.sh ---\n\n"

rm -rf /tmp/*
# may be move
rm -rf $LFS/logs

${LFSRoot}/scripts/image/config-syslinux.sh
${LFSRoot}/scripts/image/create-ramdisk.sh
${LFSRoot}/scripts/image/build-iso.sh

echo -e "--- done run-image.sh ---\n\n"
