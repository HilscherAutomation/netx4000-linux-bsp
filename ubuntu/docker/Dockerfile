FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y locales debootstrap qemu-user-static \
    build-essential gcc-arm-linux-gnueabihf sudo \
    lzop libncurses5-dev python bc apt-utils \
    kernel-package parted dosfstools mtools

RUN locale-gen en_US.UTF-8
RUN update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8
ENV TERM="xterm-color"

ARG user=ubuntu-builder
ARG uid=1000
ARG group=ubuntu-builder
ARG gid=1000

RUN groupadd -o -g ${gid} ${group}
RUN useradd -u ${uid} -g ${gid} -G sudo -m -s /bin/bash ${user}

RUN echo "%sudo   ALL=NOPASSWD:ALL" >> /etc/sudoers

USER ubuntu-builder
WORKDIR /build
