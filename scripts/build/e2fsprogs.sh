#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start e2fsprogs.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".e2fsprogs"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/e2fsprogs-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
mkdir -v build && \
cd       build && \
../configure --prefix=/usr           \
             --bindir=/bin           \
             --with-root-prefix=""   \
             --enable-elf-shlibs     \
             --disable-libblkid      \
             --disable-libuuid       \
             --disable-uuidd         \
             --disable-fsck           && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1 | tee /logs/test-e2fsprogs-`date +%s`.log
fi                                    && \
make install                          && \
chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a && \
gunzip -v /usr/share/info/libext2fs.info.gz                 && \
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info && \
if [ $LFS_DOCS -eq 1 ]; then
    makeinfo -o      doc/com_err.info ../lib/et/com_err.texinfo                && \
    install -v -m644 doc/com_err.info /usr/share/info                          && \
    install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
fi                                    && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done e2fsprogs.sh +++\n\n"
