#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start gdisk.sh for partition +++\n\n"

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | sudo gdisk /dev/nbd0
  o # new gpt
  Y # Proceed
  n
  1

  +256M
  ef00 # EFI System
  n
  2

  +2048M
  8300
  n
  3
  
  
  
  w # write GPT data
  Y # want to proceed
EOF

gdisk -l /dev/nbd0

echo -e "+++ done gdisk.sh +++\n\n"
