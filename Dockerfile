# docker build . -t "lfs_builder"
FROM ubuntu:20.04

MAINTAINER meilihao <563278383@qq.com>

RUN ln -f -s /usr/bin/bash /bin/sh && \

RUN rm /etc/bash.bashrc && \ # 4.4. Setting Up the Environment 
	
