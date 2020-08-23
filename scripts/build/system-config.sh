#!/usr/bin/env bash
set -e
echo -e "--- start system-config.sh in chroot ---\n\n"

# Static resolv.conf Configuration 
cat > /etc/resolv.conf << "EOF"
# Begin /etc/resolv.conf

nameserver 1.1.1.1
nameserver 100.100.2.136
nameserver 100.100.2.138
options timeout:2 attempts:3 rotate single-request-reopen

# End /etc/resolv.conf
EOF

# Configuring the system hostname
echo "<lfs>" > /etc/hostname

# Customizing the /etc/hosts File
cat > /etc/hosts << "EOF"
# Begin /etc/hosts

127.0.0.1 localhost.localdomain localhost

# The following lines are desirable for IPv6 capable hosts
::1       localhost ip6-localhost ip6-loopback
ff02::1   ip6-allnodes
ff02::2   ip6-allrouters

# 127.0.1.1 <FQDN> <HOSTNAME>
# <192.168.0.2> <FQDN> <HOSTNAME> [alias1] [alias2] ...

# End /etc/hosts
EOF

# Configuring the system clock
cat > /etc/adjtime << "EOF"
0.0 0 0.0
0
LOCAL
EOF

# systemctl disable systemd-timesyncd

# Creating the /etc/inputrc File
cat > /etc/inputrc << "EOF"
# Begin /etc/inputrc
# Modified by Chris Lynn <roryo@roryo.dynup.net>

# Allow the command prompt to wrap to the next line
set horizontal-scroll-mode Off

# Enable 8bit input
set meta-flag On
set input-meta On

# Turns off 8th bit stripping
set convert-meta Off

# Keep the 8th bit for display
set output-meta On

# none, visible or audible
set bell-style none

# All of the following map the escape sequence of the value
# contained in the 1st argument to the readline specific functions
"\eOd": backward-word
"\eOc": forward-word

# for linux console
"\e[1~": beginning-of-line
"\e[4~": end-of-line
"\e[5~": beginning-of-history
"\e[6~": end-of-history
"\e[3~": delete-char
"\e[2~": quoted-insert

# for xterm
"\eOH": beginning-of-line
"\eOF": end-of-line

# for Konsole
"\e[H": beginning-of-line
"\e[F": end-of-line

# End /etc/inputrc
EOF

# Creating the /etc/shells File
cat > /etc/shells << "EOF"
# Begin /etc/shells

/bin/sh
/bin/bash

# End /etc/shells
EOF

# Creating the /etc/fstab File
cat > /etc/fstab << "EOF"
# Begin /etc/fstab

# file system  mount-point  type     options             dump  fsck
#                                                              order

dev/ram        /             auto      defaults              1     1

# End /etc/fstab
EOF

echo -e "--- done system-config.sh in chroot ---\n\n"