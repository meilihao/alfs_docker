#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start texinfo2.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".texinfo2"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/texinfo-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
./configure --prefix=/usr --disable-static && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1| tee /logs/test-texinfo2-`date +%s`.log
fi                                    && \
make install                          && \
make TEXMF=/usr/share/texmf install-tex && \
pushd /usr/share/info                 && \
  rm -v dir                           && \
  for f in *
    do install-info $f dir 2>/dev/null
  done
popd                                  && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done texinfo2.sh +++\n\n"
