#!/usr/bin/env bash
set -e

# chapter 8

echo -e "--- start lfs.sh ---\n\n"

chroot "$LFS" /usr/bin/env -i   \
    LFSVersion="$LFSVersion"    \
    LFSRoot="$LFSRootInChroot"  \
    MAKEFLAGS="$MAKEFLAGS"      \
    LFS_DOCS="$LFS_DOCS"        \
    LFS_TEST="$LFS_TEST"        \
    HOME=/root                  \
    TERM="$TERM"                \
    PS1='(lfs chroot) \u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login +h \
    -c "${LFSRootInChroot}/scripts/build/run-build-in-chroot-again.sh"

chroot "$LFS" /usr/bin/env -i          \
    LFSVersion="$LFSVersion"           \
    LFSRoot="$LFSRootInChroot"         \
    MAKEFLAGS="$MAKEFLAGS"             \
    LFS_DOCS="$LFS_DOCS"               \
    LFS_TEST="$LFS_TEST"               \
    HOME=/root TERM="$TERM"            \
    PS1='(lfs chroot) \u:\w\$ '        \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login \
    -c "${LFSRootInChroot}/scripts/build/run-build-in-chroot-system-config.sh"

echo -e "--- done lfs.sh ---\n\n"
