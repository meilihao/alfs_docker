#!/usr/bin/env bash
set -e

# /bin path changed will cause error:
# Failures: 
#         From test_functions.vim:
#         Found errors in Test_Executable():
#         command line..script /tmp/tmp.JvSFkqudUj.vim/src/testdir/runtest.vim[449]..function RunTheTest[39]..Test_Executable line 41: Expected '/bin/cat' but got '/usr/bin/cat'
#         From test_terminal.vim:
#         Found errors in Test_terminal_postponed_scrollback()

echo -e "\n\n+++ start vim.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".vim"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/vim-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h && \
./configure --prefix=/usr             && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    chown -Rv tester .                    && \
    su tester -c "LANG=en_US.UTF-8 make -j1 test" &> /logs/test-vim-`date +%s`.log || true
fi                                    && \
make install                          && \
ln -sv vim /usr/bin/vi                && \
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done
ln -sv ../vim/vim82/doc /usr/share/doc/vim-8.2.2433 && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

" Ensure defaults are set before customizing settings, not after
source $VIMRUNTIME/defaults.vim
let skip_defaults_vim=1 

set nocompatible
set backspace=2
set mouse=
syntax on
if (&term == "xterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF

echo -e "+++ done vim.sh +++\n\n"
