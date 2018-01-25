FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat libsdl1.2-dev xterm python3 locales cpio \
    tmux libssl-dev iputils-ping zip libncurses5-dev

RUN locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV TERM=xterm-color

ARG user=yocto-builder
ARG uid=1000
ARG group=yocto-builder
ARG gid=1000

RUN groupadd -o -g ${gid} ${group} && \
    useradd -u ${uid} -g ${gid} -m -s /bin/bash ${user}

USER yocto-builder
WORKDIR /build
