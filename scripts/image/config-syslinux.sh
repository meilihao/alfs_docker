#!/usr/bin/env bash
set -e
echo -e "--- start config-syslinux.sh ---\n\n"

BuildDir=`mktemp -d --suffix ".syslinux"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/syslinux-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
mkdir isolinux && \
cp bios/core/isolinux.bin isolinux                 && \
cp bios/com32/elflink/ldlinux/ldlinux.c32 isolinux && \
cat > isolinux/isolinux.cfg <<"EOF"
PROMT 0
DEFAULT arch
LABEL arch
    KERNEL vmlinuz
    APPEND initrd=ramdisk.img root=/dev/ram0 3
EOF
mv -v isolinux ..                     && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "--- done config-syslinux.sh ---\n\n"