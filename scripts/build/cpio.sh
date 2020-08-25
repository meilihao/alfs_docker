#!/usr/bin/env bash
set -e

# error(by gcc-10): "/usr/bin/ld: ../gnu/libgnu.a(progname.o):/tmp/tmp.IWFVwN58EX.cpio/gnu/progname.c:33: multiple definition of `program_name'; global.o:/tmp/tmp.IWFVwN58EX.cpio/src/global.c:188: first defined here", patch location: https://git.savannah.gnu.org/cgit/cpio.git/commit/?id=641d3f489cf6238bb916368d4ba0d9325a235afb

echo -e "\n\n+++ start cpio.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".cpio"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/cpio-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
patch -Np1 -i ${LFSRoot}/sources/cpio-2.13.patch              && \
./configure --prefix=/usr \
            --bindir=/bin \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt && \
make                                    && \
if [ $LFS_DOCS -eq 1 ]; then
    makeinfo --html            -o doc/html      doc/cpio.texi && \
    makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi && \
    makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi
fi                                    && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-cpio-`date +%s`.log
fi                                    && \
make install                          && \
if [ $LFS_DOCS -eq 1 ]; then
    install -v -m755 -d /usr/share/doc/cpio-2.13/html && \
    install -v -m644    doc/html/* \
                        /usr/share/doc/cpio-2.13/html && \
    install -v -m644    doc/cpio.{html,txt} \
                        /usr/share/doc/cpio-2.13
fi                                    && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done cpio.sh +++\n\n"
