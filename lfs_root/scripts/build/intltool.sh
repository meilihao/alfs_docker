#!/usr/bin/env bash
set -e

# 在 LFS 构建环境中，已知有五个测试因为循环依赖而失败，但所有测试在 automake 安装后都能通过: [GNU Libtool 2.4.6] testsuite: 123 124 125 126 130 failed

echo -e "\n\n+++ start intltool.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".intltool"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/intltool-*.tar.gz -C ${BuildDir} --strip-components 1 && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -i 's:\\\${:\\\$\\{:' intltool-update.in && \
./configure --prefix=/usr             && \
make                                  && \
if [ $LFS_TEST -eq 1 ]; then
    make check 2>&1 | tee /logs/test-intltool-`date +%s`.log
fi                                    && \
make install                          && \
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO && \
popd                                  && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done intltool.sh +++\n\n"
