#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start ninja.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".ninja"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/ninja-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
export NINJAJOBS=4 && \
sed -i '/int Guess/a \
  int   j = 0;\
  char* jobs = getenv( "NINJAJOBS" );\
  if ( jobs != NULL ) j = atoi( jobs );\
  if ( j > 0 ) return j;\
' src/ninja.cc && \
python3 configure.py --bootstrap      && \
if [ $LFS_TEST -eq 1 ]; then
  ./ninja ninja_test 2>&1| tee /logs/test-ninja-`date +%s`.log && \
  ./ninja_test --gtest_filter=-SubprocessTest.SetWithLots 2>&1| tee -a /logs/test-ninja-`date +%s`.log
fi                                    && \
install -vm755 ninja /usr/bin/        && \
install -vDm644 misc/bash-completion /usr/share/bash-completion/completions/ninja && \
install -vDm644 misc/zsh-completion  /usr/share/zsh/site-functions/_ninja && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done ninja.sh +++\n\n"
