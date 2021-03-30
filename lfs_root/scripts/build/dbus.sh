#!/usr/bin/env bash
set -e

# `sed -i 's:/var/run:/run:' /lib/systemd/system/dbus.socket` failed, "sed: can't read /lib/systemd/system/dbus.socket: No such file or directory"
# ---
# cat config.log, found "Package libsystemd was not found in the pkg-config search path", the same error in procps-ng.

echo -e "\n\n+++ start dbus.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".dbus"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/dbus-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr                       \
            --sysconfdir=/etc                   \
            --localstatedir=/var                \
            --disable-static                    \
            --disable-doxygen-docs              \
            --disable-xml-docs                  \
            --docdir=/usr/share/doc/dbus-1.12.20 \
            --with-console-auth-dir=/run/console \
            --with-system-pid-file=/run/dbus/pid \
            --with-system-socket=/run/dbus/system_bus_socket && \
make                                  && \
make install                          && \
# mv -v /usr/lib/libdbus-1.so.* /lib    && \
# ln -sfv ../../lib/$(readlink /usr/lib/libdbus-1.so) /usr/lib/libdbus-1.so && \
ln -sfv /etc/machine-id /var/lib/dbus && \
sed -i 's:/var/run:/run:' /lib/systemd/system/dbus.socket && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done dbus.sh +++\n\n"
