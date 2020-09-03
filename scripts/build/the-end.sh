#!/usr/bin/env bash
set -e
echo -e "--- start the-end.sh in chroot ---\n\n"

echo ${LFSVersion} > /etc/lfs-release

cat > /etc/lsb-release << EOF
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="${LFSVersion}"
DISTRIB_CODENAME="BigBang"
DISTRIB_DESCRIPTION="Linux From Scratch for fun"
EOF

cat > /etc/os-release << EOF
NAME="Linux From Scratch"
VERSION="${LFSVersion}"
ID=lfs
PRETTY_NAME="Linux From Scratch ${LFSVersion}"
VERSION_CODENAME="Linux From Scratch for fun"
EOF

${LFSRoot}/scripts/build/oh-my-bash.sh

echo -e "--- done the-end.sh in chroot ---\n\n"