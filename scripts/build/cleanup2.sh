#!/usr/bin/env bash
set -e

# 8.77. Cleaning Up 

echo -e "\n\n+++ start cleanup2.sh +++\n\n"

rm -rf /tmp/*
rm -rf $LFSRoot
rm /lib/elf_ld-linux-x86-64.so.2 2>&1 || true

rm -f /usr/lib/lib{bfd,opcodes}.a
rm -f /usr/lib/libctf{,-nobfd}.a
rm -f /usr/lib/libbz2.a
rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm -f /usr/lib/libltdl.a
rm -f /usr/lib/libfl.a
rm -f /usr/lib/libz.a

find /usr/lib /usr/libexec -name \*.la -delete

if [ $LFS_DOCS -eq 0 ]; then
    rm -rf /usr/share/{info,man,doc}/*
fi

find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

rm -rf /tools

userdel -r tester || true

echo -e "+++ done cleanup2.sh +++\n\n"

# split with Chapter 9. System Configuration
# logout: not login shell: use `exit`
# logout
# `exit` is exit this script's bash env/process
exit