# USAGE: /bin/bash build_regina.sh SAGE_ROOT_DIR TARBALL_DIR

set -e  # exit when any command fails

export SAGE_ROOT=$1
export TARBALL_DIR=$2
export DEBIAN_FRONTEND=noninteractive
N_CORES=$(python3 -c 'import multiprocessing as mp; print(mp.cpu_count())')
export SNAP_PREFIX=$SAGE_ROOT/opt/snap

echo "Sage root: $SAGE_ROOT"
echo "Cores: $N_CORES"

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
    patch -p1 --input ../pari-2.3.5-no-dot-inc.patch
    export CC=gcc-4.8
    ./Configure --prefix=$SNAP_PREFIX
    make -j$N_CORES gp
    make install
    cd ..
}

build_snap () {
    unpack_source snap
    cd snap_src
    patch -p1 --input ../snap-gcc-4.8.patch
    export CC=gcc-4.8
    export CXX=g++-4.8
    ./configure LDFLAGS="-L$SNAP_PREFIX/lib -Wl,-rpath,$SNAP_PREFIX/lib" \
		--prefix=$SNAP_PREFIX --with-pari-dir=$SNAP_PREFIX
    make -j$N_CORES
    make install
    cd ..
}

build_old_pari
build_snap
