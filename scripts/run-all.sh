#!/usr/bin/env bash
set -e

echo "--- print env ---"
env
echo -e "--- print env done---\n\n"

echo "--- start build lfs ---"

# prepare to build
/scripts/prepare/run-prepare.sh
/scripts/build/run-build.sh
/scripts/image/run-image.sh

echo -e "--- done build lfs ---\n\n"
