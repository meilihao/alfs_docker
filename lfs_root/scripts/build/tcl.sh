#!/usr/bin/env bash
set -e

# clock.test failed is ok. total lfs build done, clock.test will be ok.
# http.test faild in docker with "errorInfo: couldn't open socket: Name or service not known"???. when tcl.sh done, you can replay this: `(lfs chroot) root:/tmp/tmp.xxx.tcl/tests# tclsh http.test`
# TODO: all done, recheck this.
# see [TCL tests hang on some host systems](https://www.mail-archive.com/lfs-dev@lists.linuxfromscratch.org/msg04821.html)
# 在http.test中打印url:
# ```bash
# # vim http.text
# puts "----------+ $url" # get "//a49780d42654:8010"
# test http-3.3 {http::geturl} -body {
# ...
# # hostname
# a49780d42654
# # cat /etc/hosts 
# 127.0.0.1 localhost ea874e0e2324
# ```
# a49780d42654是我当前container的host, ea874e0e2324是我用备份恢复的lfs中的container id(即当时在该container中备份lfs的), 用a49780d42654代替ea874e0e2324后, all http tests is ok.

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
sed -e "s|$SRCDIR/unix/pkgs/tdbc1.1.2|/usr/lib/tdbc1.1.2|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.2/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/tdbc1.1.2/library|/usr/lib/tcl8.6|" \
    -e "s|$SRCDIR/pkgs/tdbc1.1.2|/usr/include|"            \
    -i pkgs/tdbc1.1.2/tdbcConfig.sh   && \
sed -e "s|$SRCDIR/unix/pkgs/itcl4.2.1|/usr/lib/itcl4.2.1|" \
    -e "s|$SRCDIR/pkgs/itcl4.2.1/generic|/usr/include|"    \
    -e "s|$SRCDIR/pkgs/itcl4.2.1|/usr/include|"            \
    -i pkgs/itcl4.2.1/itclConfig.sh   && \
unset SRCDIR                          && \
if [ $LFS_TEST -eq 1 ]; then
    make test 2>&1| tee /logs/test-tcl-`date +%s`.log
fi                                    && \
make install                          && \
chmod -v u+w /usr/lib/libtcl8.6.so    && \
make install-private-headers          && \
ln -sfv tclsh8.6 /usr/bin/tclsh       && \
mv /usr/share/man/man3/{Thread,Tcl_Thread}.3 && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done tcl.sh +++\n\n"
