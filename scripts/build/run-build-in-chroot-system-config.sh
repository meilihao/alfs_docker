#!/usr/bin/env bash
set -e
echo -e "--- start run-build-in-chroot-system-config.sh in chroot ---\n\n"

${LFSRoot}/scripts/build/system-config.sh
${LFSRoot}/scripts/build/kernel.sh

echo -e "--- done run-build-in-chroot-system-config.sh in chroot ---\n\n"