#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start xml-parser.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".xml-parser"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/XML-Parser-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
perl Makefile.PL                      && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make test 2>&1| tee /logs/test-xml-parser-`date +%s`.log
fi                                    && \
make install                          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done xml-parser.sh +++\n\n"
