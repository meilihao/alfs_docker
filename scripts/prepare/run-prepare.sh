#!/usr/bin/env bash
set -e

LFS_Script_Prepare=/lfs/scripts/prepare

echo "--- start run-prepare.sh ---"

${LFS_Script_Prepare}/binutils.sh

echo -e "--- done run-prepare.sh ---\n\n"

unset  LFS_Script_Prepare
