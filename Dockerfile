# docker build . -t "lfs_builder"
FROM ubuntu:20.04

LABEL Description="Automated LFS build" Version="LFS-10.0-systemd"
MAINTAINER meilihao <563278383@qq.com>

# 从tzdata 2018版本开始（如2018d），安装过程中默认采用交互式，即要求输入指定的Geographic area和Time zone，从而必须人工值守进行安装, 否则会卡在"Configuring tzdata", build image时手动输入都没用
# 非交互时采用默认时区Etc/UTC
ENV DEBIAN_FRONTEND noninteractive

ENV LFSRoot=/mnt/lfs/lfs_root

# 保留scripts的层次结构
# 使用docker mount便于调试
#COPY scripts/ /lfs/scripts/
COPY [ "config/.bash_profile", "config/.bashrc", "/root/" ]

# 2.2. Host System Requirements
# 4.4. Setting Up the Environment
# texinfo select use 6,70
# ---
# RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
#     sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
RUN sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    apt update && \
    apt upgrade -y && \
    apt install -y vim tree locate iproute2 zip unzip genisoimage && \
    apt install -y binutils bison gawk gcc-10 g++-10 python3.8 make patch texinfo && \
    rm -rf /var/lib/apt/lists/* && \
    ln -s -f /usr/bin/bash /bin/sh && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 50 && \
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 2 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 2 && \
    ln -fs /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm /etc/bash.bashrc && \
    mkdir -pv $LFSRoot

ENTRYPOINT [ "$LFSRoot/scripts/run-in-env.sh" ]
