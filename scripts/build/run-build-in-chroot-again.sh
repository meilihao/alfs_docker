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
${LFSRoot}/scripts/build/zlib.sh
${LFSRoot}/scripts/build/bzip2.sh
${LFSRoot}/scripts/build/xz.sh
${LFSRoot}/scripts/build/zstd.sh
${LFSRoot}/scripts/build/file.sh
${LFSRoot}/scripts/build/readline.sh
${LFSRoot}/scripts/build/m4.sh
${LFSRoot}/scripts/build/bc.sh
${LFSRoot}/scripts/build/flex.sh
${LFSRoot}/scripts/build/binutils.sh
${LFSRoot}/scripts/build/gmp.sh
${LFSRoot}/scripts/build/mpfr.sh
${LFSRoot}/scripts/build/mpc.sh
${LFSRoot}/scripts/build/attr.sh

echo -e "--- done run-build-in-chroot-again in chroot ---\n\n"

echo -e "--- exit chroot again ---\n\n"

exit