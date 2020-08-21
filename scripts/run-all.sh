#!/usr/bin/env bash
set -e

# clean env
unset DEBIAN_FRONTEND

# avoid to rebuild lfs when "docker exec -it <container_id> bash"
LFS_Build_Done=~/.lfs_build_done

if [ -f ${LFS_Build_Done} ]; then
    echo "--- lfs build already done at  ---"
    cat ${LFS_Build_Done} >&1
    exit 0
fi

echo `date` > ${LFS_Build_Done}

echo "--- start version-check.sh ---"
${LFSRoot}/scripts/version-check.sh
echo -e "--- done version-check.sh ---\n\n"

echo "--- print env ---"
env
echo -e "--- print env done---\n\n"

echo -e "--- start build lfs ---\n\n"

mkdir -pv ${LFS}/{bin,etc,lib,lib64,sbin,usr,var,tools}

find ${LFSRoot}/scripts -name "*.sh" -exec chmod +x {} \;

# prepare to build
${LFSRoot}/scripts/prepare/run-prepare.sh
${LFSRoot}/scripts/build/run-build.sh
${LFSRoot}/scripts/image/run-image.sh

echo -e "--- done build lfs ---\n\n"
