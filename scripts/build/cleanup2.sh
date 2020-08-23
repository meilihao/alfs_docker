#!/usr/bin/env bash
set -e

# 8.77. Cleaning Up 

echo -e "\n\n+++ start cleanup2.sh +++\n\n"

rm -rf /tmp/*

rm /lib/elf_ld-linux-x86-64.so.2

logout

echo -e "+++ done cleanup2.sh +++\n\n"
