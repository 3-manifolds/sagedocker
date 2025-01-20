# USAGE: /bin/bash build.sh SAGE_ROOT_DIR TARBALL_DIR

set -e  # exit when any command fails


export SAGE_ROOT=$1
export TARBALL_DIR=$2
. $SAGE_ROOT/activate

unpack_source ()
{
    dir=$1_src
    rm -rf $dir
    mkdir $dir
    tar xfz $TARBALL_DIR/$1*.tar.gz --directory=$dir --strip-components=1
}

build_cyphc ()
{
    unpack_source cyphc
    cd cyphc_src
    bash getPHC.sh
    python make.py
    python -m pip install .
    python test.py
}

build_cyphc
