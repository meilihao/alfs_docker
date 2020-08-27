#!/usr/bin/env bash
set -e
echo -e "--- start run-image.sh ---\n\n"

rm -rf /tmp/*
# may be move
rm -rf $LFS/logs

if ${OnlyLFSFSRoot}; then
    echo -e "--- only package fsroot ---\n\n"

    pushd /tmp && \
    zip -9r /tmp/fsroot.zip ${LFS} -x="${LFS}/lfs_root/*" && \
    mv -v /tmp/fsroot.zip ${LFSRoot}/iso/lfs-fsroot.zip && \
    popd
else
    echo -e "--- build iso ---\n\n"
    ${LFSRoot}/scripts/image/config-syslinux.sh
    ${LFSRoot}/scripts/image/create-ramdisk.sh
    ${LFSRoot}/scripts/image/build-iso.sh
fi

echo -e "--- done run-image.sh ---\n\n"
