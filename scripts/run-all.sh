#!/usr/bin/env bash
set -e

# avoid to rebuild lfs when "docker exec -it <container_id> bash"
LFS_Build_Done=~/.lfs_build_done

if [ -f ${LFS_Build_Done} ]; then
    echo "--- lfs build already done at  ---"
    cat ${LFS_Build_Done} >&1
    exit 0
fi

echo `date` > ${LFS_Build_Done}

echo -e "--- start build lfs ---\n\n"

mkdir -pv ${LFS}/{usr/bin,usr/sbin,usr/lib,usr/lib32,usr/lib64,usr/libx32,etc,var,tools}

ln -sfv usr/bin     $LFS/bin
ln -sfv usr/sbin    $LFS/sbin
ln -sfv usr/lib     $LFS/lib
ln -sfv usr/lib32   $LFS/lib32
ln -sfv usr/lib64   $LFS/lib64
ln -sfv usr/libx32  $LFS/libx32

# logs for debug log when building and user tester can write log
mkdir -pv ${LFS}/logs
chmod 777 ${LFS}/logs

find ${LFSRoot}/scripts -name "*.sh" -exec chmod +x {} \;

${LFSRoot}/scripts/prepare/run-prepare.sh
${LFSRoot}/scripts/build/run-build.sh
${LFSRoot}/scripts/image/run-image.sh

echo -e "--- done build lfs ---\n\n"
