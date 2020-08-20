#!/usr/bin/env bash
set -e

echo -e "--- start clean-all.sh ---\n\n"

# clean env
unset DEBIAN_FRONTEND

LFS_Build_Done=~/.lfs_build_done

if [ -f ${LFS_Build_Done} ]; then
    echo -e "--- clean ${LFS_Build_Done}\n"
    rm ${LFS_Build_Done}
fi

if [ -d ${LFS} ]; then
    echo -e "--- clean ${LFS}\n"
    rm -rf ${LFS}
fi

rm -rf /tmp/*

echo -e "--- done clean-all.sh ---\n\n"
