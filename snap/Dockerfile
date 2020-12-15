########################################################################
#
# Building Snap for Ubuntu 20.04 via 18.04
#
########################################################################

FROM ubuntu:18.04
LABEL maintainer="Nathan Dunfield <nathan@dunfield.info>"

########################################################################
#
# System configuration.
#
########################################################################

RUN mkdir -p /tmp/scripts /tmp/tarballs /sage/opt/
WORKDIR /tmp/scripts

ENV SHELL /bin/bash
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -qq -y update && \ 
    apt-get -qq -y upgrade && \
    apt-get -q -y install software-properties-common build-essential &&\
    apt-get -q -y install gcc-4.8 g++-4.8 &&\
    apt-get -q -y install wget bzip2 make patch curl sudo 

RUN  adduser --quiet --shell /bin/bash --gecos "Sage user,101,," \
               --disabled-password sage \
     && chown -R sage:sage /home/sage/ \
     && echo "sage ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/01-sage \
     && chmod 0440 /etc/sudoers.d/01-sage

RUN    chown -R sage:sage /tmp/scripts /tmp/tarballs /sage/opt/

RUN add-apt-repository "deb http://archive.ubuntu.com/ubuntu focal main"
RUN apt-get -q -y install libreadline-dev

########################################################################
#
# Build Snap
#
########################################################################

USER sage
WORKDIR /tmp/scripts

COPY scripts/02_build_snap.sh .
COPY scripts/pari-2.3.5-no-dot-inc.patch .
COPY scripts/snap-gcc-4.8.patch .
ARG OLD_PARI_URL=https://pari.math.u-bordeaux.fr/pub/pari/OLD/2.3/pari-2.3.5.tar.gz
ARG SNAP_URL=https://sourceforge.net/projects/snap-pari/files/latest/download?source=file

RUN  wget -q -O /tmp/tarballs/pari_old.tar.gz $OLD_PARI_URL && \
     wget -q -O /tmp/tarballs/snap.tar.gz $SNAP_URL && \
     /bin/bash 02_build_snap.sh /sage /tmp/tarballs && \
     rm -rf /tmp/scripts/* /tmp/tarballs/*

RUN tar cfj /tmp/tarballs/opt_snap.tar.bz2 --directory /sage opt
    
USER sage
WORKDIR /home/sage
CMD ["/bin/bash"]