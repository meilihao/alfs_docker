# clean env
unset DEBIAN_FRONTEND

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
CONFIG_SITE=$LFS/usr/share/config.site
export LFS LC_ALL LFS_TGT PATH CONFIG_SITE

# because "sudo docker exec -it 8916814e8d0db909dc4cc0a96da49a25eee3135c853b9434655fd877a7538a30 bash" is not login shell,
# only use `.bashrc`
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
export LFSRoot=${LFS}/lfs_root
export LFSRootInChroot='/lfs_root'

# --- can edit args
export MAKEFLAGS='-j2'
# 1 is install doc; 0 is not
export LFS_DOCS=1
# 1 is run tests; 0 is not. running tests takes much more time
export LFS_TEST=1
export BackupBeforRealInstall=true
export LFSVersion='10.0-systemd'
# ---

alias ll='ls -ahlF --color=auto'
alias la='ls -AF --color=auto'
alias l='ls -CF --color=auto'
alias grep='grep --color=auto'
