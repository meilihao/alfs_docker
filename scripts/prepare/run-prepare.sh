#!/usr/bin/env bash
set -e

echo "--- start run-prepare.sh ---"

LFS_Script_Prepare=/lfs/scripts/prepare

${LFS_Script_Prepare}/binutils.sh
${LFS_Script_Prepare}/gcc.sh
${LFS_Script_Prepare}/linux-api-header.sh
${LFS_Script_Prepare}/glibc.sh
${LFS_Script_Prepare}/libstdc++.sh

unset LFS_Script_Prepare

echo -e "--- done run-prepare.sh ---\n\n"
