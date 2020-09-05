# changelog

## 3.0 - doing

1. build lfs = build lfs fs root + build qemu image

    构建优势: 占用空间更小, 因为使用qcow2时占用空间会一直扩容而不会缩容.

## 2.0 - failed

1. not support bios + gpt + bootable qcow2 image, only for uefi - done
1. merge qemu.md's script to scripts and not build iso - failed

    binutils test will throw "Bus error", and make /dev/nbdN offline and cant't read/write. 

## 1.0

1. lfs-10.0-systemd
1. bios/uefi + gpt + bootable qcow2 image