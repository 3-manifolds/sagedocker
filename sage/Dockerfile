########################################################################
#
# Nathan's core computational setup.
#
# Based in part on https://github.com/sagemath/docker-images/
#
########################################################################

FROM sagemath/sagemath:10.5
LABEL maintainer="Nathan Dunfield <nathan@dunfield.info>"

RUN SAGE_VENV=$(/usr/bin/sage -python -c 'import os; print(os.environ["SAGE_VENV"])') && \
    echo "export SAGE_ROOT=/home/sage/sage" >> ~sage/sage/activate && \
    echo "export SAGE_VENV=$SAGE_VENV" >> ~sage/sage/activate && \
    echo ". \$SAGE_VENV/bin/sage-env-config" >> ~sage/sage/activate && \
    echo ". \$SAGE_VENV/bin/sage-env" >> ~sage/sage/activate && \
    echo "export PATH=\$SAGE_VENV/bin:\$PATH" >> ~sage/sage/activate && \
    echo ". /home/sage/sage/activate" >> ~sage/.bashrc && \
    cd $SAGE_VENV/bin && ln -s python3 python 
 
# Install the Ubuntu packages that will be needed to build all the software.

RUN mkdir /tmp/scripts /tmp/tarballs
WORKDIR /tmp/scripts
COPY scripts/00_ubuntu_packages.sh .
RUN sudo /bin/bash 00_ubuntu_packages.sh

# Fix tkinter and delete some unneeded files.

COPY _tkinter.cpython-312-x86_64-linux-gnu.so \
     /home/sage/sage/local/var/lib/sage/venv-python3.12.5/lib/python3.12/lib-dynload
RUN rm -rf $SAGE_VENV/lib/python3.12/test

########################################################################
#
# Install "snap" from a binary tarball.
#
########################################################################

USER sage
WORKDIR /tmp/scripts

COPY opt_snap.tar.bz2 /tmp/tarballs
RUN  sudo mkdir /sage && \
     sudo tar xf /tmp/tarballs/opt_snap.tar.bz2 --directory /sage  && \
     sudo chown -R sage:sage /sage && \
     ln -s /sage/opt/snap/bin/snap /home/sage/sage/local/bin/snap && \
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
    	https://github.com/janverschelde/PHCpack/archive/$PHC_VERSION.tar.gz  && \
    /bin/bash 03_phcpy.sh /home/sage/sage /tmp/tarballs && \
    sudo rm -rf /tmp/scripts/* /tmp/tarballs/*
 
# Add in a *second* custom interface to PHC.

COPY scripts/04_cyphc.sh .
RUN wget -nv -O /tmp/tarballs/cyphc.tar.gz \
    https://github.com/3-manifolds/CyPHC/archive/master.tar.gz
RUN /bin/bash 04_cyphc.sh /home/sage/sage /tmp/tarballs  && \
    sudo rm -rf /tmp/scripts/* /tmp/tarballs/*

# Remove now Ada compiler now that we're done with it; libgnat-10 remains.

RUN sudo apt-get remove -qq -y cpp-10 gcc-10 gnat-10

# Now build Regina, installing it in a way so we can build additional
# C++ software against it.

RUN sudo apt-get -qq -y update
RUN sudo apt-get -qq -y install graphviz-dev libtokyocabinet-dev

ARG REGINAREPO=nathandunfield

# Regina 7.3 with hacked support for closed surfaces in multicusped
#  manifolds
ARG REGINA_COMMIT=1554fecbe07f2251d4595c7dd8542d43cf7331be
COPY scripts/05_build_regina.sh .
RUN wget -q -O /tmp/tarballs/regina.tar.gz \
         https://github.com/$REGINAREPO/regina/tarball/$REGINA_COMMIT && \
    /bin/bash 05_build_regina.sh /home/sage/sage /tmp/tarballs  && \
    rm -rf /tmp/tarballs/* /tmp/scripts/*

# Now, add some basic packages like pandas and also update pip and
# matplotlib to the latest and greatest.

COPY scripts/06_more_python_pkgs.sh .
RUN /bin/bash 06_more_python_pkgs.sh

# Install Heegaard
COPY scripts/09_heegaard.sh .
RUN /bin/bash 09_heegaard.sh ~sage/sage

# # Scraps, move eariler eventually
# RUN sudo apt-get update && \
#    sudo apt-get install -y some-package && \
#    sudo apt-get autoremove -y



# Finally add SnapPy and other core t3m projects

ARG SILLY=3
COPY scripts/07_snappy_and_friends.sh .
COPY scripts/test_more_cusps.py .
RUN /bin/bash 07_snappy_and_friends.sh

# Config Sage's Jupyter notebook

COPY scripts/11_config_jupyter.sh .
COPY scripts/jupyter_files .
RUN /bin/bash 11_config_jupyter.sh


USER sage
WORKDIR /home/sage
CMD ["/bin/bash"]

