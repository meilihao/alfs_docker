#!/usr/bin/env bash
set -e

## TODO : use python3 to do this by load a json config
## must run in host, because in docker only see /dev/nbdo when you are not partite /dev/nbd0

echo -e "\n\n+++ start gdisk.sh for partition +++\n\n"

sed -e 's/\s*\([\+0-9a-zA-Z]*\).*/\1/' << EOF | gdisk /dev/nbd0
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