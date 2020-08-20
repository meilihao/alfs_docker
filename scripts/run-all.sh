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

echo "--- print env ---"
env
echo -e "--- print env done---\n\n"

echo "--- start build lfs ---"

# prepare to build
/scripts/prepare/run-prepare.sh
/scripts/build/run-build.sh
/scripts/image/run-image.sh

echo -e "--- done build lfs ---\n\n"
