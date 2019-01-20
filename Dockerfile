# This dockerfile uses the ubuntu image
# VERSION 0 - EDITION 1
# Author:  Yen-Chin, Lee <yenchin@weintek.com>
# Command format: Instruction [arguments / command] ..

FROM ubuntu:14.04
MAINTAINER Aging Chan, aging@illuminos.sg

# Add 32bit package in package list
RUN dpkg --add-architecture i386

# Update package infos first
RUN apt-get update -y

## Install requred packages:
# http://www.yoctoproject.org/docs/current/ref-manual/ref-manual.html

# Essentials
RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib \
     build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
     xz-utils debianutils iputils-ping vim bc g++-multilib

# Documentation
RUN apt-get install -y make xsltproc docbook-utils fop dblatex xmlto

# OpenEmbedded Self-Test
RUN apt-get install -y python-git

# i.MX layers host packages for a Ubuntu 12.04 or 14.04 host
RUN apt-get install -y libsdl1.2-dev xterm sed cvs subversion coreutils \
      texi2html docbook-utils python-pysqlite2 help2man make gcc g++ \
      desktop-file-utils libgl1-mesa-dev libglu1-mesa-dev mercurial \
      autoconf automake groff curl lzop asciidoc libssl-dev u-boot-tools

# Extra package for Xilinx PetaLinux
RUN apt-get install -y xvfb libtool libncurses5-dev libssl-dev zlib1g-dev:i386 tftpd

# Install repo tool for some bsp case, like NXP's yocto
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /usr/bin/repo
RUN chmod a+x /usr/bin/repo

# Install Java
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get install -y software-properties-common && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Set the locale, else yocto will complain
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN useradd -ms /bin/bash yocto

# default workdir is /yocto
WORKDIR /yocto

# Add entry point, we use entrypoint.sh to mapping host user to
# container
# COPY .gitconfig /home/yocto/.gitconfig
RUN git config --system user.name "Aging Chan"
RUN git config --system user.email "aging.chan@gmail.com"

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
