# USAGE: /bin/bash build_regina.sh SAGE_ROOT_DIR TARBALL_DIR

export SAGE_ROOT=$1
export TARBALL_DIR=$2
export SCRIPT_DIR=$(pwd)
. "$SAGE_ROOT/local/bin/sage-env" >&2 
N_CORES=$(python -c 'import multiprocessing as mp; print(mp.cpu_count())')

echo "Sage local: $SAGE_LOCAL"
echo "Cores: $N_CORES"

unpack_source ()
{
    dir=$1_src
    rm -rf $dir
    mkdir $dir
    tar xfz $TARBALL_DIR/$1*.tar.gz --directory=$dir --strip-components=1
}

build_jansson ()
{
    unpack_source jansson
    cd jansson_src
    ./configure --prefix=$SAGE_LOCAL
    make -j$N_CORES
    make install
    cd ..    
}

build_tokyocabinet () 
{
    unpack_source tokyocabinet
    cd tokyocabinet_src
    ./configure --prefix=$SAGE_LOCAL
    make -j$N_CORES
    make install
    cd ..
}

build_regina ()
{
    unpack_source regina
    mkdir regina_src/build
    cd regina_src/build
    cmake -DCMAKE_PREFIX_PATH=$SAGE_LOCAL \
          -DCMAKE_INCLUDE_PATH=$SAGE_LOCAL \
          -DCMAKE_LIBRARY_PATH=$SAGE_LOCAL/lib \
          -DCMAKE_INSTALL_PREFIX=$SAGE_LOCAL \
	  -DBoost_NO_BOOST_CMAKE=ON \
	  -DBoost_INCLUDE_DIR=$SAGE_LOCAL/include \
          -DDISABLE_GUI=1 -DREGINA_INSTALL_TYPE=XDG ..
    make -j$N_CORES install
    cd ../..
}

#build_jansson
#unpack_source boost
build_tokyocabinet
build_regina
