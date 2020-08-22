#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start cleanup.sh +++\n\n"

find /usr/{lib,libexec} -name \*.la -delete

# rm -rf /usr/share/{info,man,doc}

echo -e "+++ done cleanup.sh +++\n\n"