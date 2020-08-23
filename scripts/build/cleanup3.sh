#!/usr/bin/env bash
set -e

# 8.77. Cleaning Up 

echo -e "\n\n+++ start cleanup3.sh +++\n\n"

rm -f /usr/lib/lib{bfd,opcodes}.a
rm -f /usr/lib/libctf{,-nobfd}.a
rm -f /usr/lib/libbz2.a
rm -f /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm -f /usr/lib/libltdl.a
rm -f /usr/lib/libfl.a
rm -f /usr/lib/libz.a

find /usr/lib /usr/libexec -name \*.la -delete

find /usr -depth -name $(uname -m)-lfs-linux-gnu\* | xargs rm -rf

rm -rf /tools

userdel -r tester

# split with Chapter 9. System Configuration
logout

echo -e "+++ done cleanup3.sh +++\n\n"
