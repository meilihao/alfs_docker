# 4.4. Setting Up the Environment
# $PATH add /sbin for use chroot
set +h
umask 022
LFS=/mnt/lfs
LC_ALL=POSIX
LFS_TGT=$(uname -m)-lfs-linux-gnu
PATH=/usr/bin:/usr/sbin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
if [ ! -L /sbin ]; then PATH=/sbin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
export LFS LC_ALL LFS_TGT PATH
export MAKEFLAGS='-j2'
alias ll='ls -alF --color=auto'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# not auto to build lfs
#${LFSRoot}/scripts/run-all.sh
