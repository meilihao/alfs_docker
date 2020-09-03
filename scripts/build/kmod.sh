#!/usr/bin/env bash
set -e

# when --with-rootlibdir=/lib get error:
# if test "/usr/lib" != "/lib"; then \
# 	/bin/mkdir -p /lib && \
# 	so_img_name=$(readlink /usr/lib/libkmod.so) && \
# 	so_img_rel_target_prefix=$(echo /usr/lib | sed 's,\(^/\|\)[^/][^/]*,..,g') && \
# 	ln -sf $so_img_rel_target_prefix/lib/$so_img_name /usr/lib/libkmod.so && \
# 	mv /usr/lib/libkmod.so.* /lib; \
# fi
# mv: '/usr/lib/libkmod.so.2' and '/lib/libkmod.so.2' are the same file
# mv: '/usr/lib/libkmod.so.2.3.5' and '/lib/libkmod.so.2.3.5' are the same file
# make[3]: *** [Makefile:3026: install-exec-hook] Error 1

echo -e "\n\n+++ start kmod.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".kmod"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/kmod-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr          \
            --bindir=/bin          \
            --sysconfdir=/etc      \
            --with-rootlibdir=/usr/lib   \
            --with-xz              \
            --with-zlib               && \
make                                  && \
make install

for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sfv ../bin/kmod /sbin/$target
done

ln -sfv kmod /bin/lsmod               && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done kmod.sh +++\n\n"
