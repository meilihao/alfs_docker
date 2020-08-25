#!/usr/bin/env bash
set -e

# 8.77. Cleaning Up 

echo -e "\n\n+++ start cleanup2.sh +++\n\n"

rm -rf /tmp/*

rm /lib/elf_ld-linux-x86-64.so.2 || true

# logout: not login shell: use `exit'
# logout
exit

echo -e "+++ done cleanup2.sh +++\n\n"
