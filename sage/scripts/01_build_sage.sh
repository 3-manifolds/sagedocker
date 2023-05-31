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
N_CORES=$(python3 -c 'import multiprocessing as mp; print(max(mp.cpu_count(), 4))')

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
if [ ! -f "./configure" ]; then
    sudo -H -E -u sage make configure
fi
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
    echo "Remove build dir"
    rm -rf build/
    echo "Removing pyc files and Cython garbage"
    (cd src && \
     rm -rf c_lib .cython_version cython_debug; \
     rm -rf build; find . -name '*.pyc' | xargs rm -f; \
     rm -f $(find . -name "*.pyx" | sed 's/\(.*\)[.]pyx$$/\1.c \1.cpp/'))
    echo "Stripping binaries ..."
    LC_ALL=C find local/lib local/bin local/var/lib/sage/venv-python* -type f -exec strip '{}' ';' 2>&1 | grep -i -v "File format not recognized" |  grep -i -v "File truncated" || true
    echo "Removing sphinx artifacts..."
    rm -rf local/share/doc/sage/doctrees local/share/doc/sage/inventory
    echo "Removing documentation. Inspection in IPython still works."
    rm -rf local/share/doc local/share/*/doc local/share/*/examples local/share/singular/html
    rm -rf upstream
    rm -rf .git
    rm -rf /tmp/tarballs/sage.tar.gz
fi

# Setup all the paths and the ".sage" directory for the sage user.
echo exit | sudo -H -E -u sage /sage/sage


SAGE_VENV=$(/usr/bin/sage -python -c 'import os; print(os.environ["SAGE_VENV"])')

# Alias "python" to "python3"

sudo -H -E -u sage ln -s $SAGE_VENV/bin/python3 $SAGE_VENV/bin/python

# Make SAGE_LOCAL everyones default environment
echo "export SAGE_ROOT=/sage" >> /sage/activate
echo "export SAGE_VENV=$SAGE_VENV" >> /sage/activate
echo ". \$SAGE_VENV/bin/sage-env-config" >> /sage/activate
echo ". \$SAGE_VENV/bin/sage-env" >> /sage/activate
echo ". /sage/activate" >> ~root/.bashrc
echo ". /sage/activate" >> ~sage/.bashrc

