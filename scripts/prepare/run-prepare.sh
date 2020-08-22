#!/usr/bin/env bash
set -e
set -x

# The cross-compiler will be installed in a separate $LFS/tools directory, since it will not be part of the final system. 

echo "--- start run-prepare.sh ---"

LFS_Script_Prepare=${LFSRoot}/scripts/prepare

${LFS_Script_Prepare}/binutils.sh
${LFS_Script_Prepare}/gcc.sh
${LFS_Script_Prepare}/linux-api-header.sh
${LFS_Script_Prepare}/glibc.sh
${LFS_Script_Prepare}/libstdc++.sh
${LFS_Script_Prepare}/m4.sh
${LFS_Script_Prepare}/ncurses.sh
${LFS_Script_Prepare}/bash.sh
${LFS_Script_Prepare}/coreutils.sh
${LFS_Script_Prepare}/diffutils.sh
${LFS_Script_Prepare}/file.sh
${LFS_Script_Prepare}/findutils.sh
${LFS_Script_Prepare}/gawk.sh
${LFS_Script_Prepare}/grep.sh
${LFS_Script_Prepare}/gzip.sh
${LFS_Script_Prepare}/make.sh
${LFS_Script_Prepare}/patch.sh
${LFS_Script_Prepare}/sed.sh
${LFS_Script_Prepare}/tar.sh
${LFS_Script_Prepare}/xz.sh
${LFS_Script_Prepare}/binutils2.sh
${LFS_Script_Prepare}/gcc2.sh

unset LFS_Script_Prepare

echo -e "--- done run-prepare.sh ---\n\n"
