#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start kernel.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".kernel"`
KernelVersion=`ls ${LFSRoot}/sources/linux-*.tar.xz|xargs -n 1 basename |sed 's/linux-\(.*\)\.tar\.xz/\1/g'`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/linux-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
make mrproper  && \
cp -fv ${LFSRoot}/sources/.config ${BuildDir} && \
make           && \
make modules_install && \
cp -iv arch/x86/boot/bzImage /boot/vmlinuz-${KernelVersion}-lfs-${LFSVersion} && \
cp -iv System.map /boot/System.map-${KernelVersion} && \
cp -iv .config /boot/config-${KernelVersion}        && \
if [ $LFS_DOCS -eq 1 ]; then
    install -d /usr/share/doc/linux-${KernelVersion}
    cp -r Documentation/* /usr/share/doc/linux-${KernelVersion}
fi                                       && \
rm -rf ${BuildDir}

# install -v -m755 -d /etc/modprobe.d
# cat > /etc/modprobe.d/usb.conf << "EOF"
# # Begin /etc/modprobe.d/usb.conf

# install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
# install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# # End /etc/modprobe.d/usb.conf
# EOF

unset BuildDir
unset KernelVersion

echo -e "+++ done kernel.sh +++\n\n"
