########################################################################
#
# Variant for testing the SnapPy works in SageMath tip.  
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

COPY scripts/01_build_sage.sh .
RUN  git clone git://github.com/sagemath/sage.git /sage && \
     cd /sage && \
     git checkout develop && \
     chown -R sage:sage /sage
     
RUN  cd /tmp/scripts && \
     /bin/bash 01_build_sage.sh && \
     chown -R sage:sage /tmp/scripts /tmp/tarballs

# Now, add some basic packages like pandas and also update pip and
# matplotlib to the latest and greatest.
    
COPY scripts/04_more_python_pkgs.sh .
RUN /bin/bash 04_more_python_pkgs.sh
    
# Now add SnapPy and other core t3m projects

ARG SILLY=TRUE4
COPY scripts/05_snappy_and_friends.sh .
RUN /bin/bash 05_snappy_and_friends.sh


# Setup for when you start the container.  Can always sudo to root
# without password if need be.

USER sage
WORKDIR /home/sage
CMD ["/bin/bash"]
