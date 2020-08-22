#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start tcl.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".tcl"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/tcl*-html.tar.gz -C ${BuildDir} --strip-components 1 && \
tar -xf ${LFSRoot}/sources/tcl*-src.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
SRCDIR=$(pwd)  && \
cd unix        && \
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            $([ "$(uname -m)" = x86_64 ] && echo --enable-64bit) && \
make           && \
sed -e "s|$SRCDIR/unix|/usr/lib|" \
    -e "s|$SRCDIR|/usr/include|"  \
    -i tclConfig.sh && \
sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.1|/usr/lib/tdbc1.1.1|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.1/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/tdbc1.1.1/library|/usr/lib/tcl8.6|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.1|/usr/include|"            \
    -i pkgs/tdbc1.1.1/tdbcConfig.sh   && \
sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.0|/usr/lib/itcl4.2.0|" \
    -e "s|$SRCDIR/pkgs/itcl4.2.0/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.2.0|/usr/include|"            \
    -i pkgs/itcl4.2.0/itclConfig.sh   && \
unset SRCDIR                          && \
make test                             && \
make install                          && \
chmod -v u+w /usr/lib/libtcl8.6.so    && \
make install-private-headers          && \
ln -sfv tclsh8.6 /usr/bin/tclsh       && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done tcl.sh +++\n\n"
