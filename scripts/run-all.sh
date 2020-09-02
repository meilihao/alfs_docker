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

${LFSRoot}/scripts/version-check.sh
${LFSRoot}/scripts/gdisk.sh

echo -e "--- start build lfs ---\n\n"

mkdir -pv ${LFS}/{bin,etc,lib,lib64,sbin,usr,var,tools}

# logs for debug log when building and user tester can write log
mkdir -pv ${LFS}/logs
chmod 777 ${LFS}/logs

find ${LFSRoot}/scripts -name "*.sh" -exec chmod +x {} \;

${LFSRoot}/scripts/prepare/run-prepare.sh
${LFSRoot}/scripts/build/run-build.sh
${LFSRoot}/scripts/image/run-image.sh

echo -e "--- done build lfs ---\n\n"
