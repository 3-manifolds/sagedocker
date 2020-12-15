# !!!NOTE!!! This script is intended to be run with root privileges
# It will run as the 'sage' user when the time is right.

if [ ! -d "/sage" ]; then
    mkdir /sage
    tar xfz /tmp/tarballs/sage.tar.gz --directory=/sage --strip-components=1
fi

set -e  # exit when any command fails
chown -R sage:sage /sage

# Cap the number of cores at four as have had problems when it tries
# to use large numbers of cores.
N_CORES=$(python -c 'import multiprocessing as mp; print(max(mp.cpu_count(), 4))')

# The next line builds Sage so that it supports more processors,
# specifically avoiding certain newer processor instructions.  As of
# 2019/12/27, need to switch to "no" to build on Ubuntu 18.04.
export SAGE_FAT_BINARY="no"

# Make sure Sage doesn't try to build its own GCC (even though it
# shouldn't sense we've already installed a recent gcc and gfortran)
export SAGE_INSTALL_GCC="no"
export MAKE="make -j${N_CORES}"
export V=0  # Print less during build

# Sage can't be built as root, for reasons...
# Here -E inherits the environment from root, however it's important to
# include -H to set HOME=/home/sage, otherwise DOT_SAGE will not be set
# correctly and the build will fail!
cd /sage
sudo -H -E -u sage ./configure
sudo -H -E -u sage make build || exit 1

# Add aliases for sage and sagemath
ln -sf "/sage/sage" /usr/bin/sage

# Install some optional Sage packages
# As of 9.2, giac_sage is included, as sage.libs.giac
sudo -H -E -u sage ./sage -i pynormaliz

# Clean up artifacts from the sage build that we don't need for runtime or
# running the tests
#
# For the 'develop' image we leave everything as it would be after a
# successful sage build
if [ "$BRANCH" != "develop" ]; then
  make micro_release
  rm -rf .git
  rm -rf /tmp/tarballs/sage.tar.gz
fi

# Setup all the paths and the ".sage" directory for the sage user.
echo exit | sudo -H -E -u sage /sage/sage

# Make SAGE_LOCAL everyones default environment
echo "export SAGE_ROOT=/sage" >> ~root/.bashrc
echo ". /sage/local/bin/sage-env-config" >> ~root/.bashrc
echo ". /sage/local/bin/sage-env" >> ~root/.bashrc
echo "export SAGE_ROOT=/sage" >> ~sage/.bashrc
echo ". /sage/local/bin/sage-env-config" >> ~sage/.bashrc
echo ". /sage/local/bin/sage-env" >> ~sage/.bashrc
