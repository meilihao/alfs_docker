#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start systemd.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".systemd"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/systemd-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
ln -sf /bin/true /usr/bin/xsltproc && \
tar -xf ${LFSRoot}/sources/systemd-man-pages-*.tar.xz && \
sed '181,$ d' -i src/resolve/meson.build         && \
sed -i 's/GROUP="render"/GROUP="video"/' rules.d/50-udev-default.rules.in && \
mkdir -p build && \
cd       build && \
LANG=en_US.UTF-8                    \
meson --prefix=/usr                 \
      --sysconfdir=/etc             \
      --localstatedir=/var          \
      -Dblkid=true                  \
      -Dbuildtype=release           \
      -Ddefault-dnssec=no           \
      -Dfirstboot=false             \
      -Dinstall-tests=false         \
      -Dkmod-path=/bin/kmod         \
      -Dldconfig=false              \
      -Dmount-path=/bin/mount       \
      -Drootprefix=                 \
      -Drootlibdir=/lib             \
      -Dsplit-usr=true              \
      -Dsulogin-path=/sbin/sulogin  \
      -Dsysusers=false              \
      -Dumount-path=/bin/umount     \
      -Db_lto=false                 \
      -Drpmmacrosdir=no             \
      -Dhomed=false                 \
      -Duserdb=false                \
      -Dman=true                    \
      -Dmode=release                \
      -Ddocdir=/usr/share/doc/systemd-247 \
      ..   && \
LANG=en_US.UTF-8 ninja                && \
LANG=en_US.UTF-8 ninja install        && \
rm -f /usr/bin/xsltproc               && \
rm -rf /usr/lib/pam.d                 && \
systemd-machine-id-setup              && \
systemctl preset-all                  && \
systemctl disable systemd-time-wait-sync.service && \
rm -f /usr/lib/sysctl.d/50-pid-max.conf && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done systemd.sh +++\n\n"
