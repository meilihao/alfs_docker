#!/usr/bin/env bash
set -e

echo -e "\n\n+++ start glibc-config.sh +++\n\n"

cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

BuildDir=`mktemp -d --suffix ".tzdata"`

echo -e "+++ build path: ${BuildDir}\n"

tar -xf ${LFSRoot}/sources/tzdata*.tar.gz -C ${BuildDir} && \
pushd ${PWD}   && \
cd ${BuildDir} && \
ZONEINFO=/usr/share/zoneinfo        && \
mkdir -pv $ZONEINFO/{posix,right}
for tz in etcetera southamerica northamerica europe africa antarctica  \
          asia australasia backward; do
    zic -L /dev/null   -d $ZONEINFO       ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix ${tz}
    zic -L leapseconds -d $ZONEINFO/right ${tz}
done
cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO && \
# zic -d $ZONEINFO -p America/New_York && \
zic -d $ZONEINFO -p Asia/Shanghai   && \
ln -sfv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
unset ZONEINFO                      && \
popd                                && \
rm -rf ${BuildDir}

unset BuildDir

cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF

# dynamic loader search a directory  
cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
mkdir -pv /etc/ld.so.conf.d

echo -e "+++ done glibc-config.sh +++\n\n"
