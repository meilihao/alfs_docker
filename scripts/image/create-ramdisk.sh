#!/usr/bin/env bash
set -e
echo -e "--- start create-ramdisk.sh ---\n\n"

BuildDir=`mktemp -d --suffix ".ramdisk"`

LOOP=/dev/loop0
IMAGE=isolinux/ramdisk.img
# inital ram disk size in KB
# must be in sync with CONFIG_BLK_DEV_RAM_SIZE in .config and enough physical memory
# but using my .config-5.8.1 from ubuntu, 最终RAMDISK需要2.5g的空间, 且当时未知要修改CONFIG_BLK_DEV_RAM_SIZE, 因此创建BootableISO的方法是失败的
IMAGE_SIZE=900000
LOOP_DIR=${BuildDir}/$LOOP
RAMDISK=${BuildDir}/ramdisk

# Create yet another loop device if not exist
[ -e $LOOP ] || mknod $LOOP b 7 0

# create ramdisk file of IMAGE_SIZE
dd if=/dev/zero of=$RAMDISK bs=1k count=$IMAGE_SIZE

# plug off any virtual fs from loop device
losetup -d $LOOP || true

# associate it with ${LOOP}
losetup $LOOP $RAMDISK

# make an ext4 filesystem
mkfs.ext4 -q -m 0 $LOOP $IMAGE_SIZE

# ensure loop2 directory
[ -d $LOOP_DIR ] || mkdir -pv $LOOP_DIR

# mount it
mount $LOOP $LOOP_DIR
rm -rf $LOOP_DIR/lost+found

# copy LFS system without build artifacts
pushd $LFS
cp -dpR $(ls -A | grep -Ev "lfs_root") $LOOP_DIR
popd

# show statistics
df $LOOP_DIR

echo "Compressing system ramdisk image.."
bzip2 -c $RAMDISK > $IMAGE

# Copy compressed image to /tmp dir (need for dockerhub)
cp -v $IMAGE /tmp

# Cleanup
umount $LOOP_DIR
losetup -d $LOOP
rm -rf $LOOP_DIR
rm -f $RAMDISK

rm -rf ${BuildDir}
unset BuildDir

echo -e "--- done create-ramdisk.sh ---\n\n"