# jhalfs by linuxfromscratch.org
version:  LFS-10.0-systemd-rc1

## steps
1. get jhalfs

    `svn co svn://svn.linuxfromscratch.org/ALFS/jhalfs/trunk jhalfs-dev` # in 20200825
1. install packages need by jhalfs

    `apt install libxml2-utils xsltproc bison gawk texinfo docbook-xml docbook-xsl`
1. prepare with an account which has sudo permission.

    ```
    $ useradd -m jhalfs
    $ passwd  jhalfs
    $ visudo # 在打开的文件内加入`jhalfs ALL=(ALL)ALL`
    $ su -  jhalfs
    $ ###
    $ svn list svn://svn.linuxfromscratch.org/LFS/tags # get all tags in LFS
    $ sudo mkdir /mnt/build_dir
    $ sudo chmod 777 /mnt/build_dir
    $ wget https://mirror-hk.koddos.net/lfs/lfs-packages/lfs-packages-10.0-rc1.tar
    $ tar -xvf lfs-packages-10.0.tar
    ```
1. make && config

    1. `cd jhalfs-dev && make` to config
    1. when exit, jhalfs will check params.
    1. `make -C /mnt/build_dir/jhalfs`, start to build

## jhalfs config
1. BOOK Settings

    Use BOOK (Linux From Scratch systemd)  ---> 
    
        (X) Linux From Scratch systemd
    Release (SVN)  ---> 
    
        ( ) SVN # use Current Development, **不推荐**
        ( ) Working Copy # 选择所使用的书籍的绝对路径, 比如`svn co http://svn.linuxfromscratch.org/LFS/tags/10.0-rc1 lfs-10.0-rc1
        (X) Branch or stable book # **推荐**", 比如"9.1", "10.0-rc1", 此时由jhalfs下载book, 默认放在`/mnt/build_dir/jhalfs/lfs-<tag>`里
    (10.0-rc1) Branch (preceded by "branch-"), stable Version, or tag
        Mutilib (Standard LFS on i686 or amd64)  --->
    [ ] Add blfs-tool support
    [ ] Add custom tools support
1. General Settings  --->

    (/mnt/build_dir) Build Directory # lfs构建目录, 建议使用官方默认的lfs目录
    [*] Retrieve source files
    (/mnt/build_dir/10.0-rc1) Package Archive Directory # 上面下载的lfs-packages-10.0.tar的解压目录的绝对路径, 如果不设置, 它默认会自动去`(http://ftp.osuosl.org) FTP mirror`指定的地址下载, 并保持到`${Build Directory}/sources`下
    [*]     Retry on 'connection refused' failure
    (20)    Number of retry attempts on download failures
    (30)    Download timeout (in seconds)
    (http://ftp.osuosl.org) FTP mirror
    [*] Run the makefile
    [*] Rebuild files # 每次都会重新清理目录 /mnt/build_dir
1. Build Settings  --->

    [*] Run testsuites
            Test settings  --->

                Tests level (All final system testsuites)  --->
                Flavour (Abort the build on the first test failure)  --->
    [ ] Package management
    [*] Create a log of installed files for each package
    [*] Strip Installed Binaries/Libraries
    [*] Remove libtool .la files
    [ ] DO NOT use/display progress_bar
1. System configuration   --->

    [ ] Use a custom fstab file
    [*] Build the kernel
    (/boot/config-5.4.0-42-generic) Kernel config file
    [ ] Install non-wide-character ncurses
    (Asia/Shanghai) TimeZone
    (zh_CN.UTF-8) Language
    [ ] Install the full set of locales
        Groff page size (A4)  --->
    (hello-lfs) Hostname (see help)
        Network configuration  --->

            (eth0) netword card name
            (10.0.2.9) Static IP address
            (10.0.2.2) Gateway
            (24) Subnet prefix
            (10.0.2.255) Broadcast address
            (local) Domain name (see help)
            (10.0.2.3) Primary Name server
            (8.8.8.8) Secondary Name server
        Console configuration  --->
            (us) Keymap name
            [*] Hardware clock is set to local time
1. Advanced Features  --->

    [*] Create SBU and disk usage report
    [*] Save Chapter 5 work
    [*] Run comparison analysis on final stage
    (3)     Number of test runs (2,3,4,5)
    [*] Optimization and parallelization
            Optimization settings  --->

                (1) Number of parallel `make' jobs
                Optimization level (Final system only)  --->

        Internal Settings (WARNING: for jhalfs developers only)  --->
1. [ ] Rebuild the Makefile (see help)

configuration:
```conf
# Generated by Kconfiglib (https://github.com/ulfalizer/Kconfiglib)

#
# BOOK Settings
#
# BOOK_LFS is not set
BOOK_LFS_SYSD=y
# BOOK_CLFS is not set
# BOOK_CLFS2 is not set
# BOOK_CLFS3 is not set
# BOOK_BLFS is not set
INITSYS="systemd"
PROGNAME="lfs"
RUN_ME="./jhalfs run"
# relSVN is not set
# WORKING_COPY is not set
BRANCH=y
BRANCH_ID="10.0-rc1"
LFS_MULTILIB_NO=y
# LFS_MULTILIB_I686 is not set
# LFS_MULTILIB_X32 is not set
# LFS_MULTILIB_ALL is not set
MULTILIB="default"
PLATFORM="GENERIC"
SPARC64_PROC="none"
# BLFS_TOOL is not set
# CUSTOM_TOOLS is not set
# end of BOOK Settings

#
# General Settings
#
LUSER="lfs"
LGROUP="lfs"
LHOME="/home"
BUILDDIR="/mnt/build_dir"
GETPKG=y
SRC_ARCHIVE="/mnt/build_dir/10.0-rc1"
RETRYSRCDOWNLOAD=y
RETRYDOWNLOADCNT=20
DOWNLOADTIMEOUT=30
SERVER="http://ftp.osuosl.org"
RUNMAKE=y
CLEAN=y
# end of General Settings

#
# Build Settings
#
CONFIG_TESTS=y

#
# Test settings
#
# TST_1 is not set
TST_2=y
# TST_3 is not set
# NO_BOMB is not set
BOMB=y
# end of Test settings

TEST=2
BOMB_TEST=y
# PKGMNGT is not set
INSTALL_LOG=y
STRIP=y
DEL_LA_FILES=y
# NO_PROGRESS_BAR is not set
# end of Build Settings

#
# System configuration
#
# HAVE_FSTAB is not set
CONFIG_BUILD_KERNEL=y
CONFIG="/boot/config-5.4.0-42-generic"
# NCURSES5 is not set
TIMEZONE="Asia/Shanghai"
LANG="zh_CN.UTF-8"
# FULL_LOCALE is not set
PAGE_LETTER=y
# PAGE_A4 is not set
PAGE="letter"
HOSTNAME="hello-lfs"

#
# Network configuration
#
INTERFACE="eth0"
IP_ADDR="10.0.2.9"
GATEWAY="10.0.2.2"
PREFIX="24"
BROADCAST="10.0.2.255"
DOMAIN="local"
DNS1="10.0.2.3"
DNS2="8.8.8.8"
# end of Network configuration

#
# Console configuration
#
FONT="lat0-16"
KEYMAP="us"
LOCAL=y
# end of Console configuration
# end of System configuration

#
# Advanced Features
#
REPORT=y
SAVE_CH5=y
COMPARE=y
ITERATIONS=3
RUN_ICA=y
CONFIG_OPTIMIZE=y

#
# Optimization settings
#
N_PARALLEL=1
OPT_1=y
# OPT_2 is not set
# end of Optimization settings

OPTIMIZE=1

#
# Internal Settings (WARNING: for jhalfs developers only)
#
SCRIPT_ROOT="jhalfs"
JHALFSDIR="$BUILDDIR/$SCRIPT_ROOT"
LOGDIRBASE="logs"
LOGDIR="$JHALFSDIR/$LOGDIRBASE"
TESTLOGDIRBASE="test-logs"
TESTLOGDIR="$JHALFSDIR/$TESTLOGDIRBASE"
FILELOGDIRBASE="installed-files"
FILELOGDIR="$JHALFSDIR/$FILELOGDIRBASE"
ICALOGDIR="$LOGDIR/ICA"
MKFILE="$JHALFSDIR/Makefile"
XSL="$PROGNAME.xsl"
PKG_LST="unpacked"
# end of Internal Settings (WARNING: for jhalfs developers only)
# end of Advanced Features

# REBUILD_MAKEFILE is not set
```

jhalfs生成的构建Makefile入口是`/mnt/build_dir/jhalfs/Makefile`.

## FAQ
###
error log:
```log
xsltproc --nonet --xinclude --stringparam profile.revision systemd --stringparam profile.arch default --output prbook.xml /mnt/build_dir/jhalfs/lfs-10.0-rc1/stylesheets/lfs-xsl/profile.xsl /mnt/build_dir/jhalfs/lfs-10.0-rc1/index.xml
I/O error : Attempt to load network entity http://docbook.sourceforge.net/release/xsl/current/profiling/profile-mode.xsl
warning: failed to load external entity "http://docbook.sourceforge.net/release/xsl/current/profiling/profile-mode.xsl"
compilation error: file /mnt/build_dir/jhalfs/lfs-10.0-rc1/stylesheets/lfs-xsl/profile.xsl line 15 element import
xsl:import : unable to load http://docbook.sourceforge.net/release/xsl/current/profiling/profile-mode.xsl
I/O error : Attempt to load network entity http://docbook.sourceforge.net/release/xsl/current/common/stripns.xsl
warning: failed to load external entity "http://docbook.sourceforge.net/release/xsl/current/common/stripns.xsl"
compilation error: file /mnt/build_dir/jhalfs/lfs-10.0-rc1/stylesheets/lfs-xsl/profile.xsl line 19 element import
xsl:import : unable to load http://docbook.sourceforge.net/release/xsl/current/common/stripns.xsl
```

查看/mnt/build_dir/jhalfs/lfs-10.0-rc1/stylesheets/lfs-xsl/profile.xsl和/mnt/build_dir/jhalfs/lfs-10.0-rc1/index.xml的文件头部内容, 再结合[网上文章](https://wiki.archlinux.org/index.php/DocBook), 推测是缺少解析xml的组件.

解决方法: `apt install docbook-xml docbook-xsl`即可.