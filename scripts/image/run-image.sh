#!/usr/bin/env bash
set -e
echo -e "--- start run-image.sh ---\n\n"

rm -rf /tmp/*
# may be move
rm -rf $LFS/logs

# use zip because tar打包$LFS在其他机器(deepin v20)解压时报错, 但在ubuntu 20.04的docker容器中解压又是正常的.
pushd /tmp && \
zip -9r -y /tmp/fsroot.zip ${LFS} -x="${LFS}/lfs_root/*" && \
if [ -f ${LFSRoot}/iso/lfs-fsroot.zip ]; then
    mv -v ${LFSRoot}/iso/lfs-fsroot.zip ${LFSRoot}/iso/lfs-fsroot-`date +%s`.zip
fi                                                    && \
mv -v /tmp/fsroot.zip ${LFSRoot}/iso/lfs-fsroot.zip   && \
popd

echo -e "--- done run-image.sh ---\n\n"