#!/usr/bin/env bash
set -e
echo -e "--- start the-end.sh in chroot ---\n\n"

echo 10.0-systemd-rc1 > /etc/lfs-release

cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="10.0-systemd-rc1"
DISTRIB_CODENAME="BigBang"
DISTRIB_DESCRIPTION="Linux From Scratch for fun"
EOF

cat > /etc/os-release << "EOF"
NAME="Linux From Scratch"
VERSION="10.0-systemd-rc1"
ID=lfs
PRETTY_NAME="Linux From Scratch 10.0-systemd-rc1"
VERSION_CODENAME="Linux From Scratch for fun"
EOF

rm -rf /tmp/*

echo -e "--- done the-end.sh in chroot ---\n\n"