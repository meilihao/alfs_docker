#!/usr/bin/env bash
set -e
echo -e "--- start run-build-in-chroot-again in chroot ---\n\n"

${LFSRoot}/scripts/build/man-pages.sh
${LFSRoot}/scripts/build/tcl.sh
${LFSRoot}/scripts/build/expect.sh
${LFSRoot}/scripts/build/dejagun.sh
${LFSRoot}/scripts/build/iana-etc.sh
${LFSRoot}/scripts/build/glibc.sh
${LFSRoot}/scripts/build/glibc-config.sh

echo -e "--- done run-build-in-chroot-again in chroot ---\n\n"

echo -e "--- exit chroot again ---\n\n"

exit