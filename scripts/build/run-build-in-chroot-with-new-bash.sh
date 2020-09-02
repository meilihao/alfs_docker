#!/usr/bin/env bash
set -e
echo -e "--- start run-build-in-chroot-with-new-bash.sh in chroot ---\n\n"

${LFSRoot}/scripts/build/libtool.sh
${LFSRoot}/scripts/build/gdbm.sh
${LFSRoot}/scripts/build/gperf.sh
${LFSRoot}/scripts/build/expat.sh
${LFSRoot}/scripts/build/inetutils.sh
${LFSRoot}/scripts/build/perl2.sh
${LFSRoot}/scripts/build/xml-parser.sh
${LFSRoot}/scripts/build/intltool.sh
${LFSRoot}/scripts/build/autoconf.sh
${LFSRoot}/scripts/build/automake.sh
${LFSRoot}/scripts/build/kmod.sh
${LFSRoot}/scripts/build/libelf.sh
${LFSRoot}/scripts/build/libffi.sh
${LFSRoot}/scripts/build/openssl.sh
${LFSRoot}/scripts/build/python3.sh
${LFSRoot}/scripts/build/ninja.sh
${LFSRoot}/scripts/build/meson.sh
${LFSRoot}/scripts/build/coreutils.sh
${LFSRoot}/scripts/build/check.sh
${LFSRoot}/scripts/build/diffutils.sh
${LFSRoot}/scripts/build/gawk.sh
${LFSRoot}/scripts/build/findutils.sh
${LFSRoot}/scripts/build/groff.sh
${LFSRoot}/scripts/build/grub.sh
${LFSRoot}/scripts/build/less.sh
${LFSRoot}/scripts/build/gzip.sh
${LFSRoot}/scripts/build/iproute2.sh
${LFSRoot}/scripts/build/kbd.sh
${LFSRoot}/scripts/build/libpipeline.sh
${LFSRoot}/scripts/build/make.sh
${LFSRoot}/scripts/build/patch.sh
${LFSRoot}/scripts/build/man-db.sh
${LFSRoot}/scripts/build/tar.sh
${LFSRoot}/scripts/build/texinfo2.sh
${LFSRoot}/scripts/build/vim.sh
${LFSRoot}/scripts/build/systemd.sh
${LFSRoot}/scripts/build/dbus.sh
${LFSRoot}/scripts/build/procps-ng.sh
${LFSRoot}/scripts/build/util-linux2.sh
${LFSRoot}/scripts/build/e2fsprogs.sh
${LFSRoot}/scripts/build/stripping-again.sh

echo -e "--- done run-build-in-chroot-with-new-bash.sh in chroot ---\n\n"