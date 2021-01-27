########################################################################
#
# Gets the specified version of the offical sagemath dev image, updates
# git to tip, installs sage-trac, and builds any incremental changes.
#
# See README.txt for usage
#
########################################################################

FROM sagemath/sagemath-dev:develop
LABEL maintainer="Nathan Dunfield <nathan@dunfield.info>"

WORKDIR /home/sage/sage

# Need an editor to actually do work
RUN sudo apt-get update && \
    sudo apt-get install -y emacs-nox nano
    
# Get a copy of the git repo (which is not in the image), and build
# any incremental changes.  The convoluted sequence of git calls is
# to prevent timestamp changes that would force much recompilation.
RUN git fetch trac develop
RUN git reset --soft remotes/trac/develop && \
    git reset --keep && \
    git -c user.name=docker-build -c user.email=docker-build@sage.invalid stash && \
    set -e && \
    make build
RUN git clone https://github.com/sagemath/git-trac-command.git ../git-trac && \
    echo ". /home/sage/git-trac/enable.sh" >> ~sage/.bashrc


USER sage
WORKDIR /home/sage/sage
ENTRYPOINT ["/bin/bash"]