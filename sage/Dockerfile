########################################################################
#
# Nathan's core computational setup. 
#
# Based in part on https://github.com/sagemath/docker-images/
#
########################################################################

FROM ubuntu:16.04
LABEL maintainer="Nathan Dunfield <nathan@dunfield.info>"

########################################################################
#
# System configuration.
#
########################################################################

# Install the Ubuntu packages that will be needed to build all the software.
# See the file for details, but know that we will be using gcc 7.

RUN mkdir /tmp/scripts /tmp/tarballs
WORKDIR /tmp/scripts
COPY scripts/00_ubuntu_packages.sh .
RUN /bin/bash 00_ubuntu_packages.sh
 
# We *have* to add a non-root user since sage cannot be built as root
# However, we do allow the 'sage' user to use sudo without a password

RUN  adduser --quiet --shell /bin/bash --gecos "Sage user,101,," \
               --disabled-password sage \
     && chown -R sage:sage /home/sage/ \
     && echo "sage ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/01-sage \
     && chmod 0440 /etc/sudoers.d/01-sage
ENV SHELL /bin/bash
ENV SAGE_BANNER bare
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

########################################################################
#
# Build SageMath itself
#
########################################################################

COPY scripts/01_build_sage.sh .
ARG SAGE_VERSION=8.9
ARG SAGE_URL=http://mirrors.mit.edu/sage/src/sage-$SAGE_VERSION.tar.gz
#ARG SAGE_URL=https://github.com/sagemath/sage/tarball/develop
RUN  wget -q -O /tmp/tarballs/sage.tar.gz $SAGE_URL && \
     /bin/bash 01_build_sage.sh && \
     chown -R sage:sage /tmp/scripts /tmp/tarballs

#RUN git clone git://github.com/sagemath/sage.git /sage
#RUN cd /sage && \
#    git checkout develop && \
#    git remote add trac git://trac.sagemath.org/sage.git -t master && \
#    git remote set-url --push trac git@trac.sagemath.org:sage.git && \
#    git fetch trac u/jdemeyer/backport_python_trashcan_patch && \
#    git checkout -b trashcan FETCH_HEAD && \
#    cd /tmp/scripts && \
#    /bin/bash 01_build_sage.sh && \
#    chown -R sage:sage /tmp/scripts /tmp/tarballs

# Config Sage's Jupyter notebook

COPY scripts/jupyter_notebook_config.py .
COPY scripts/sage-notebook.patch .
RUN cat jupyter_notebook_config.py >>   \
       /sage/local/etc/jupyter/jupyter_notebook_config.py  && \ 
    patch /sage/local/bin/sage-notebook sage-notebook.patch  && \ 
    patch /sage/src/bin/sage-notebook sage-notebook.patch

########################################################################
#
# Build one thing that is independent of Sage
#
########################################################################

USER sage
WORKDIR /tmp/scripts

COPY scripts/02_build_snap.sh .
ARG OLD_PARI_URL=https://pari.math.u-bordeaux.fr/pub/pari/OLD/2.3/pari-2.3.5.tar.gz
ARG SNAP_URL=https://sourceforge.net/projects/snap-pari/files/latest/download?source=file

RUN  wget -q -O /tmp/tarballs/pari_old.tar.gz $OLD_PARI_URL && \
     wget -q -O /tmp/tarballs/snap.tar.gz $SNAP_URL && \
     /bin/bash 02_build_snap.sh /sage /tmp/tarballs && \
     ln -s /sage/opt/snap/bin/snap /sage/local/bin/snap && \
     rm -rf /tmp/scripts/* /tmp/tarballs/* 

########################################################################
#
# Add additional Python packages, include SnapPy, Regina, and PHCpack
#
########################################################################

# Build order is the reverse of how frequently I expect to change
# things, start with the Python interface to PHCpack.

ARG QD_VERSION=2.3.22
ARG PHC_VERSION=v2.4.64

COPY scripts/03_phcpy.sh .
COPY scripts/makefile_unix.patch . 

RUN wget -nv -O /tmp/tarballs/qd.tar.gz \
        https://www.davidhbailey.com/dhbsoftware/qd-$QD_VERSION.tar.gz && \
    wget -nv -O /tmp/tarballs/PHC.tar.gz \
    	https://github.com/janverschelde/PHCpack/archive/$PHC_VERSION.tar.gz && \
    /bin/bash 03_phcpy.sh /sage /tmp/tarballs  && \
    sudo rm -rf /tmp/scripts/* /tmp/tarballs/* 

# Add in a *second* custom interface to PHC.  

COPY scripts/04_cyphc.sh .
RUN wget -nv -O /tmp/tarballs/cyphc.tar.gz \
        https://bitbucket.org/t3m/cyphc/get/tip.tar.gz && \
    /bin/bash 04_cyphc.sh /sage /tmp/tarballs  && \
    sudo rm -rf /tmp/scripts/* /tmp/tarballs/*

# Now build Regina, installing it in a way so we can build additional
# C++ software against it.
#
# SageMath 8.* comes with a small headers only version of Boost 1.58,
# which we simply clobber.  Boost 1.61 is the newest version than can
# be used with the system's CMake 3.5.

ARG REGINAREPO=regina-normal
ARG REGINA_COMMIT=01f5627d214afe5d6

COPY scripts/05_build_regina.sh .
RUN wget -q -O /tmp/tarballs/boost.tar.gz   \ 
         http://sf.net/projects/boost/files/boost/1.61.0/boost_1_61_0.tar.gz && \
    wget -q -O /tmp/tarballs/tokyocabinet.tar.gz   \ 
         http://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz && \
    wget -q -O /tmp/tarballs/regina.tar.gz \
         https://github.com/$REGINAREPO/regina/tarball/$REGINA_COMMIT && \
    /bin/bash 05_build_regina.sh /sage /tmp/tarballs && \
    rm -rf /tmp/tarballs/* /tmp/scripts/*

# Now, add some basic packages like pandas and also update pip and
# matplotlib to the latest and greatest.
    
COPY scripts/06_more_python_pkgs.sh .
RUN /bin/bash 06_more_python_pkgs.sh


# Finally add SnapPy and other core t3m projects

ARG SILLY=15
COPY scripts/07_snappy_and_friends.sh .
RUN /bin/bash 07_snappy_and_friends.sh

# Install Graphviz and PyGraphviz
COPY scripts/08_graphviz.sh .
RUN wget -q -O /tmp/tarballs/graphviz.tar.gz   \ 
         https://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz && \
    /bin/bash 08_graphviz.sh /sage /tmp/tarballs && \
    rm -rf /tmp/tarballs/* /tmp/scripts/*

# Install Heegaard

COPY scripts/09_heegaard.sh .
RUN /bin/bash 09_heegaard.sh

# Setup for when you start the container.  Can always sudo to root
# without password if need be.

# Install HIKMOT

COPY scripts/10_hikmot.sh .
COPY scripts/hikmot.patch .
RUN wget -q -O /tmp/tarballs/hikmot.tar.gz   \ 
         http://www.oishi.info.waseda.ac.jp/~takayasu/hikmot/Codes/hikmot_v1.0.1.tar.gz && \
    /bin/bash 10_hikmot.sh /sage /tmp/tarballs

# Scraps, move eariler eventually
#RUN sudo apt-get update && \
#    sudo apt-get install -y time && \
#    sudo apt-get autoremove -y

USER sage
WORKDIR /home/sage
CMD ["/bin/bash"]