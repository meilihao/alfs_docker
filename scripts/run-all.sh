#!/usr/bin/env bash
set -e

echo "--- start version-check.sh ---"
/scripts/version-check.sh
echo "--- done version-check.sh ---"

echo "--- print env ---"
env
echo "--- print env done---"

echo "--- start build lfs ---"

# prepare to build
/scripts/prepare/run-prepare.sh
/scripts/build/run-build.sh
/scripts/image/run-image.sh

echo "--- done build lfs ---"