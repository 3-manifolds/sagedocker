# USAGE: /bin/bash this_script.sh SAGE_ROOT_DIR TARBALL_DIR

set -e  # exit when any command fails
export SAGE_ROOT=$1
export TARBALL_DIR=$2
. "$SAGE_ROOT/local/bin/sage-env-config" >&2 
. "$SAGE_ROOT/local/bin/sage-env" >&2 
echo "Sage local: $SAGE_LOCAL"

unpack_source ()
{
    dir=$1_src
    rm -rf $dir
    mkdir $dir
    tar xfz $TARBALL_DIR/$1.tar.gz --directory=$dir --strip-components=1
}

build_hikmot ()
{
    unpack_source hikmot
    cd hikmot_src
    patch --input /tmp/scripts/hikmot.patch python_src/hikmot.py
    sage -python -m pip install .
}

build_hikmot
