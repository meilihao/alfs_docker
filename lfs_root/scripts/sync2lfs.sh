#!/usr/bin/env bash
set -e

# unuse

echo -e "--- start sync2lfs.sh ---\n\n"

rsync -av /mnt/lfs_root ${LFS} && chown -R root:root ${LFSRoot}

echo -e "+++ done sync2lfs.sh +++\n\n"