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
export LFS LC_ALL LFS_TGT PATH

# because "sudo docker exec -it 8916814e8d0db909dc4cc0a96da49a25eee3135c853b9434655fd877a7538a30 bash" is not login shell,
# only use ``.bashrc`
export MAKEFLAGS='-j2'
export PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
# 1 is install doc; 0 is not
export LFS_DOCS=1
# 1 is run tests; 0 is not. running tests takes much more time
export LFS_TEST=1
export LFSRootInChroot='/lfs_root'

alias ll='ls -alF --color=auto'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'

# not auto to build lfs
#${LFSRoot}/scripts/run-all.sh
