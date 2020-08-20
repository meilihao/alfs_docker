#!/usr/bin/env bash
set -e
echo "--- start run-build.sh ---"

LFS_Script_Build=/lfs/scripts/build

${LFS_Script_Build}/prepare-vkfs.sh

unset LFS_Script_Build

echo -e "--- done run-build.sh ---\n\n"
