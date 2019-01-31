# USAGE: /bin/bash this_script.sh SAGE_ROOT_DIR TARBALL_DIR
#
# Installs Graphviz and PyGraphviz.  We don't use the Ubuntu package
# for Graphviz because it is not compiled with the GTS triangulation
# library, making the "sfdp" layout engine much less useful.


export SAGE_ROOT=$1
export TARBALL_DIR=$2
. "$SAGE_ROOT/local/bin/sage-env" >&2 
echo "Sage local: $SAGE_LOCAL"


unpack_source ()
{
    dir=$1_src
    rm -rf $dir
    mkdir $dir
    tar xfz $TARBALL_DIR/$1.tar.gz --directory=$dir --strip-components=1
}


build_graphviz ()
{
    sudo apt-get update
    sudo apt-get install -y libgts-dev libpango1.0-dev
    unpack_source graphviz
    cd graphviz_src
    pkg-config --libs gts
    pkg-config --cflags gts
    ./configure --with-gts --prefix=$SAGE_LOCAL
    make
    make install
    sage -pip install pygraphviz
}


build_graphviz
