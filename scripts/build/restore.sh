#!/usr/bin/env bash
set -e
echo -e "--- start run-restore.sh ---\n\n"

pushd ${LFS} && \
rm -rf `ls ${LFS} |egrep -v lfs_root` && \
tar -xpf ${LFSRoot}/iso/lfs-temp-tools-10.0-systemd-rc1.tar.gz && \
popd

echo -e "--- done run-restore.sh ---\n\n"
