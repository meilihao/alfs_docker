#!/usr/bin/env bash
set -e

# binutils test on qemu+/dev/nbd0 got error:
# --- log start
# ...
# Testsuite summary for gold 0.1
# ============================================================================
# # TOTAL: 4
# # PASS:  4
# # SKIP:  0
# # XFAIL: 0
# # FAIL:  0
# # XPASS: 0
# # ERROR: 0
# ============================================================================
# make[5]: Leaving directory '/tmp/tmp.QAZNaMPXy3.binutils/build/gold'
# make[4]: Leaving directory '/tmp/tmp.QAZNaMPXy3.binutils/build/gold'
# make[3]: Leaving directory '/tmp/tmp.QAZNaMPXy3.binutils/build/gold'
# make[2]: Leaving directory '/tmp/tmp.QAZNaMPXy3.binutils/build/gold'
# /mnt/lfs/lfs_root/scripts/build/run-build.sh: line 51: 20878 Bus error               chroot "$LFS" /usr/bin/env -i LFSVersion="$LFSVersion" LFSRoot="$LFSRootInChroot" MAKEFLAGS="$MAKEFLAGS" LFS_DOCS="$LFS_DOCS" LFS_TEST="$LFS_TEST" HOME=/root TERM="$TERM" PS1='(lfs chroot) \u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin /bin/bash --login +h -c "${LFSRootInChroot}/scripts/build/run-build-in-chroot-again.sh"
# root@ea874e0e2324:/# ll /mnt/lfs
# ls: reading directory '/mnt/lfs': Input/output error
# total 0
# sudo gdisk -l /dev/nbd0 # from host
# GPT fdisk (gdisk) version 1.0.3

# Warning! Read error 5; strange behavior now likely!
# Warning! Read error 5; strange behavior now likely!
# Partition table scan:
#   MBR: not present
#   BSD: not present
#   APM: not present
#   GPT: not present

# Creating new GPT entries.
# Disk /dev/nbd0: 33554432 sectors, 16.0 GiB
# Sector size (logical/physical): 512/512 bytes
# Disk identifier (GUID): 9494068D-B74F-49DE-B0A2-078DB1AEC088
# Partition table holds up to 128 entries
# Main partition table begins at sector 2 and ends at sector 33
# First usable sector is 34, last usable sector is 33554398
# Partitions will be aligned on 2048-sector boundaries
# Total free space is 33554365 sectors (16.0 GiB)

# Number  Start (sector)    End (sector)  Size       Code  Name
# --- end


echo -e "\n\n+++ start binutils.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".binutils"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/binutils-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
expect -c "spawn ls" |grep "spawn ls"                 && \
sed -i '/@\tincremental_copy/d' gold/testsuite/Makefile.in                       && \
mkdir -v build && \
cd       build && \
../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib       && \
make tooldir=/usr                     && \
if [ $LFS_TEST -eq 1 ]; then
    make -k check 2>&1 | tee /logs/test-binutils-`date +%s`.log
fi                                    && \
make tooldir=/usr install             && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done binutils.sh +++\n\n"
