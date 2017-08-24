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

########################################################################
#
# Build SageMath itself
#
########################################################################

ARG SAGE_VERSION=8.0

COPY scripts/01_build_sage.sh .
RUN  wget -q -O /tmp/tarballs/sage.tar.gz \
          http://mirrors.mit.edu/sage/src/sage-$SAGE_VERSION.tar.gz && \
     /bin/bash 01_build_sage.sh && \
     chown -R sage:sage /tmp/scripts /tmp/tarballs

########################################################################
#
# Add additional Python packages, include SnapPy, Regina, and PHCpack
#
########################################################################

# Build order is the reverse of how frequently I expect to change
# things, start with the Python interface to PHCpack.

USER sage
WORKDIR /tmp/scripts

ARG QD_VERSION=2.3.17
ARG PHC_VERSION=v2.4.43

COPY scripts/02_phcpy.sh .
COPY scripts/makefile_unix.patch . 

RUN wget -nv -O /tmp/tarballs/qd.tar.gz \
        http://crd.lbl.gov/~dhbailey/mpdist/qd-$QD_VERSION.tar.gz && \
    wget -nv -O /tmp/tarballs/PHC.tar.gz \
    	https://github.com/janverschelde/PHCpack/archive/$PHC_VERSION.tar.gz && \
    /bin/bash 02_phcpy.sh /sage /tmp/tarballs  && \
    sudo rm -rf /tmp/scripts/* /tmp/tarballs/* 



# Second, build Regina, installing it in a way so we can build
# additional C++ software against it.
#
# SageMath 8.0 comes with a small headers only version of Boost 1.58,
# which we simply clobber.

# Current master, but doesn't work for gcc 7.
# ARG REGINAREPO=regina-normal
# ARG REGINA_COMMIT=52a3941

ARG REGINAREPO=NathanDunfield
ARG REGINA_COMMIT=24cc12d

COPY scripts/03_build_regina.sh .
RUN wget -q -O /tmp/tarballs/boost.tar.gz   \ 
         http://sf.net/projects/boost/files/boost/1.64.0/boost_1_64_0.tar.gz && \
    wget -q -O /tmp/tarballs/tokyocabinet.tar.gz   \ 
         http://fallabs.com/tokyocabinet/tokyocabinet-1.4.48.tar.gz && \
    wget -q -O /tmp/tarballs/regina.tar.gz \
         https://github.com/$REGINAREPO/regina/tarball/$REGINA_COMMIT && \
    /bin/bash 03_build_regina.sh /sage /tmp/tarballs && \
    rm -rf /tmp/tarballs/* /tmp/scripts/*


# Now, add some basic packages like pandas and also update pip and
# matplotlib to the latest and greatest.
    
COPY scripts/04_more_python_pkgs.sh .
RUN /bin/bash 04_more_python_pkgs.sh

    
# Now add SnapPy and other core t3m projects
    
COPY scripts/05_snappy_and_friends.sh .
RUN /bin/bash 05_snappy_and_friends.sh


# Setup for when you start the container.  Can always sudo to root
# without password if need be.

USER sage
WORKDIR /home/sage
CMD ["/bin/bash"]
