########################################################################
#
# Nathan's core computational setup.
#
# Based in part on https://github.com/sagemath/docker-images/
#
########################################################################

FROM ubuntu:22.04
LABEL maintainer="Nathan Dunfield <nathan@dunfield.info>"

########################################################################
#
# System configuration.
#
########################################################################

# Install the Ubuntu packages that will be needed to build all the software.

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
# Build development version of SageMath itself
#
########################################################################

COPY scripts/01_build_sage.sh .
ARG SAGE_VERSION=10.5
ARG SAGE_URL=http://mirrors.mit.edu/sage/src/sage-$SAGE_VERSION.tar.gz
# ARG SAGE_URL=https://github.com/sagemath/sage/tarball/develop

RUN  wget -q -O /tmp/tarballs/sage.tar.gz $SAGE_URL && \
     /bin/bash 01_build_sage.sh && \
     chown -R sage:sage /tmp/scripts /tmp/tarballs

# COPY scripts/01e_build_sage.sh .
# RUN /bin/bash 01e_build_sage.sh

# RUN git clone git://github.com/sagemath/sage.git /sage
# RUN cd /sage && \
#     git config --global user.email "sage@none.com" && \
#     git config --global user.name "Sage Docker" && \
#     git checkout develop && \
#     git remote add trac git://trac.sagemath.org/sage.git -t master && \
#     git remote set-url --push trac git@trac.sagemath.org:sage.git && \
#     #git fetch trac u/dunfield/nf_warning && \
#     #git checkout -b nf_warning FETCH_HEAD && \
#     #git merge develop && \
#     cd /tmp/scripts && \
#     /bin/bash 01_build_sage.sh && \
#     chown -R sage:sage /tmp/scripts /tmp/tarballs

# ARG SILLY=1
COPY scripts/07_snappy_and_friends.sh .
RUN /bin/bash 07_snappy_and_friends.sh

########################################################################
#
# Install "snap" from a binary tarball.
#
########################################################################

USER sage
WORKDIR /tmp/scripts

COPY opt_snap.tar.bz2 /tmp/tarballs
RUN  tar xf /tmp/tarballs/opt_snap.tar.bz2 --directory /sage  && \
     ln -s /sage/opt/snap/bin/snap /sage/local/bin/snap && \
     sudo rm -rf /tmp/scripts/* /tmp/tarballs/*

########################################################################
#
# Add additional Python packages, include SnapPy, Regina, and PHCpack
#
########################################################################

# Build order is the reverse of how frequently I expect to change
# things, start with the Python interface to PHCpack.

ARG QD_VERSION=2.3.22
ARG PHC_VERSION=v2.4.88

COPY scripts/03_phcpy.sh .
COPY scripts/PHC.patch .

RUN wget -nv -O /tmp/tarballs/qd.tar.gz \
        https://www.davidhbailey.com/dhbsoftware/qd-$QD_VERSION.tar.gz && \
    wget -nv -O /tmp/tarballs/PHC.tar.gz \
    	https://github.com/janverschelde/PHCpack/archive/$PHC_VERSION.tar.gz && \
    /bin/bash 03_phcpy.sh /sage /tmp/tarballs   && \
    sudo rm -rf /tmp/scripts/* /tmp/tarballs/*

# Add in a *second* custom interface to PHC.

COPY scripts/04_cyphc.sh .
RUN wget -nv -O /tmp/tarballs/cyphc.tar.gz \
    https://github.com/3-manifolds/CyPHC/archive/master.tar.gz
RUN /bin/bash 04_cyphc.sh /sage /tmp/tarballs  && \
    sudo rm -rf /tmp/scripts/* /tmp/tarballs/*

# Now build Regina, installing it in a way so we can build additional
# C++ software against it.

RUN sudo apt-get -qq -y update
RUN sudo apt-get -qq -y install python3-tk graphviz-dev libtokyocabinet-dev

ARG REGINAREPO=nathandunfield

# Regina 7.3 with hacked support for closed surfaces in multicusped
#  manifolds
ARG REGINA_COMMIT=1554fecbe07f2251d4595c7dd8542d43cf7331be
COPY scripts/05_build_regina.sh .
#RUN mv /sage/local/include/libnormaliz /sage/local/include/libnormaliz_tmp
RUN wget -q -O /tmp/tarballs/regina.tar.gz \
         https://github.com/$REGINAREPO/regina/tarball/$REGINA_COMMIT && \
    /bin/bash 05_build_regina.sh /sage /tmp/tarballs  && \
    rm -rf /tmp/tarballs/* /tmp/scripts/*

# Now, add some basic packages like pandas and also update pip and
# matplotlib to the latest and greatest.

COPY scripts/06_more_python_pkgs.sh .
RUN /bin/bash 06_more_python_pkgs.sh


# Finally add SnapPy and other core t3m projects

# ARG SILLY=1
# COPY scripts/07_snappy_and_friends.sh .
# RUN /bin/bash 07_snappy_and_friends.sh

# Install Graphviz and PyGraphviz --- no longer needed with Ubuntu 20.04
# COPY scripts/08_graphviz.sh .
# RUN wget -q -O /tmp/tarballs/graphviz.tar.gz   \
#         https://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/graphviz.tar.gz && \
#    /bin/bash 08_graphviz.sh /sage /tmp/tarballs && \
#    rm -rf /tmp/tarballs/* /tmp/scripts/*

# Install Heegaard
COPY scripts/09_heegaard.sh .
RUN /bin/bash 09_heegaard.sh /sage

# # Scraps, move eariler eventually
# RUN sudo apt-get update && \
#    sudo apt-get install -y some-package && \
#    sudo apt-get autoremove -y


# Config Sage's Jupyter notebook

# COPY scripts/11_config_jupyter.sh .
# COPY scripts/jupyter_notebook_config.py .
# COPY scripts/jupyter_lab_config.py .
# COPY scripts/sage-notebook.patch .
# RUN /bin/bash 11_config_jupyter.sh


# Setup for when you start the container.  Can always sudo to root
# without password if need be.

USER sage
WORKDIR /home/sage
CMD ["/bin/bash"]