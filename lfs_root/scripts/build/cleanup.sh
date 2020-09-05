#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start cleanup.sh +++\n\n"

find /usr/{lib,libexec} -name \*.la -delete

if [ $LFS_DOCS -eq 0 ]; then
    rm -rf /usr/share/{info,man,doc}/*
fi

echo -e "+++ done cleanup.sh +++\n\n"