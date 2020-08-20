#!/usr/bin/env bash
set -e

LFS_Script_Prepare=/lfs/scripts/prepare
export LFS_Sources_Root=/lfs/sources

echo "--- start run-prepare.sh ---"

${LFS_Script_Prepare}/binutils.sh

echo -e "--- done run-prepare.sh ---\n\n"

unset LFS_Script_Prepare
unset LFS_Sources_Root
