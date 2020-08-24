#!/usr/bin/env bash
set -e

# 8.40. Perl-5.32.0

echo -e "\n\n+++ start perl2.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".perl2"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/perl-*.tar.xz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
export BUILD_ZLIB=False && \
export BUILD_BZIP2=0    && \
sh Configure -des                                         \
             -Dprefix=/usr                                \
             -Dvendorprefix=/usr                          \
             -Dprivlib=/usr/lib/perl5/5.32/core_perl      \
             -Darchlib=/usr/lib/perl5/5.32/core_perl      \
             -Dsitelib=/usr/lib/perl5/5.32/site_perl      \
             -Dsitearch=/usr/lib/perl5/5.32/site_perl     \
             -Dvendorlib=/usr/lib/perl5/5.32/vendor_perl  \
             -Dvendorarch=/usr/lib/perl5/5.32/vendor_perl \
             -Dman1dir=/usr/share/man/man1                \
             -Dman3dir=/usr/share/man/man3                \
             -Dpager="/usr/bin/less -isR"                 \
             -Duseshrplib                                 \
             -Dusethreads             && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make test 2>&1 | tee /logs/test-perl2-`date +%s`.log || true
fi                                    && \
make install                          && \
unset BUILD_ZLIB BUILD_BZIP2          && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done perl2.sh +++\n\n"
