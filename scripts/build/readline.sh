#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start readline.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".readline"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/readline-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i '/MV.*old/d' Makefile.in              && \
sed -i '/{OLDSUFF}/c:' support/shlib-install && \
./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/readline-8.0  && \
make SHLIB_LIBS="-lncursesw"          && \
make SHLIB_LIBS="-lncursesw" install  && \
mv -v /usr/lib/lib{readline,history}.so.* /lib                                   && \
chmod -v u+w /lib/lib{readline,history}.so.*                                     && \
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so    && \
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so     && \
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.0             && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done readline.sh +++\n\n"
