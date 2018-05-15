# USAGE: /bin/bash build_regina.sh SAGE_ROOT_DIR TARBALL_DIR

export SAGE_ROOT=$1
export TARBALL_DIR=$2
export DEBIAN_FRONTEND=noninteractive
N_CORES=$(python -c 'import multiprocessing as mp; print(mp.cpu_count())')
export SNAP_PREFIX=$SAGE_ROOT/opt/snap

echo "Sage root: $SAGE_ROOT"
echo "Cores: $N_CORES"

install_old_gcc ()
{
    apt-get -y -qq update
    apt-get -y install gcc-4.6 g++-4.6 libreadline-dev
}

unpack_source ()
{
    dir=$1_src
    rm -rf $dir
    mkdir $dir
    tar xfz $TARBALL_DIR/$1.tar.gz --directory=$dir --strip-components=1
}

build_old_pari (){
    unpack_source pari_old
    cd pari_old_src
    export CC=gcc-4.6
    ./Configure --prefix=$SNAP_PREFIX
    make -j$N_CORES gp
    make install
}

build_snap () {
    unpack_source snap
    cd snap_src
    export CC=gcc-4.6
    export CXX=g++-4.6
    ./configure LDFLAGS="-L$SNAP_PREFIX/lib -Wl,-rpath,$SNAP_PREFIX/lib" \
		--prefix=$SNAP_PREFIX --with-pari-dir=$SNAP_PREFIX
    make -j$N_CORES
    make install
}

remove_old_gcc ()
{
    apt-get -y remove gcc-4.6 g++-4.6 libreadline-dev
    apt -y autoremove
    apt-get clean
    rm -rf /var/lib/apt/lists/*
}

install_old_gcc 
build_old_pari
build_snap
remove_old_gcc
