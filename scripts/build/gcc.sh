#!/usr/bin/env bash
set -e
set -x

# /tmp need 1777 because make check will write somethon in /tmp, otherwise `mkdir: cannot create directory '/tmp/dg-combine-results-18903-8450': Permission denied` will lead to `FAIL: gcc.c-torture/execute/builtins/fprintf.c execution,  -O0`
# follow error is ok, by compare with http://www.linuxfromscratch.org/lfs/build-logs/10.0-rc1/i5-6600K/logs/824-gcc-10.2.0
# make: *** [Makefile:2350: do-check] Error 2
# make: Target 'check' not remade because of errors

echo -e "\n\n+++ start gcc.sh +++\n\n"

BuildDir=`mktemp -d --suffix ".gcc"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/gcc-*.tar.xz -C ${BuildDir} --strip-components 1 && \
# for tester can access ${BuildDir}, default tester can't write ${BuildDir}
chmod 755 ${BuildDir} && \
pushd ${PWD}   && \
cd ${BuildDir} && \
sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64                                   && \
mkdir -v build && \
cd build       && \
../configure --prefix=/usr            \
             LD=ld                    \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --with-system-zlib       && \
make                                  && \
ulimit -s 32768                       && \
chown -Rv tester .                    && \
su tester -c "PATH=$PATH make -k check V=1 2>&1 | tee /logs/test-gcc-`date +%s`.log || true" && \
../contrib/test_summary               && \
make install                          && \
rm -rf /usr/lib/gcc/$(gcc -dumpmachine)/10.2.0/include-fixed/bits/ && \
chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/10.2.0/include{,-fixed} && \
ln -sv ../usr/bin/cpp /lib             && \
install -v -dm755 /usr/lib/bfd-plugins && \
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/10.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/          && \
echo 'int main(){}' > dummy.c          && \
cc dummy.c -v -Wl,--verbose &> dummy.log && \
readelf -l a.out | grep ': /lib' | grep "/lib64/ld-linux-x86-64.so.2" && \
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log | wc -l |grep "3"  && \
grep -B4 '^ /usr/include' dummy.log |grep "include"                   && \
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g' |grep "SEARCH_DIR" && \
grep "/lib.*/libc.so.6 " dummy.log |grep "/lib/libc.so.6 succeeded"   && \
grep found dummy.log | grep "ld-linux-x86-64.so.2"                    && \
rm -v dummy.c a.out dummy.log                           && \
mkdir -pv /usr/share/gdb/auto-load/usr/lib              && \
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib || true  && \
popd                                                    && \
rm -rf ${BuildDir}

unset BuildDir

echo -e "+++ done gcc.sh +++\n\n"
