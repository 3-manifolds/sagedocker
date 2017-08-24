# USAGE: /bin/bash build_regina.sh SAGE_ROOT_DIR TARBALL_DIR

export SAGE_ROOT=$1
export TARBALL_DIR=$2
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

build_boost ()
{
    # WARNING: this clobbers Sage's own "boost_cropped" includes!
    unpack_source boost
    cd boost_src
    rm -rf $SAGE_LOCAL/include/boost
    ./bootstrap.sh --prefix=$SAGE_LOCAL \
    --with-libraries=python,regex,iostreams
    ./b2 --layout=tagged install threading=multi -j$N_CORES
    # I don't know why the following isn't handled automatically, but
    # it appears to be as of 2017/8.
    if [[ "$OSTYPE" == "darwin"* ]]; then
        for library in $SAGE_LOCAL/lib/libboost*.dylib; do
 	    install_name_tool -id $library $library
	done
    fi
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
          -DCMAKE_INCLUDE_PATH=$SAGE_LOCAL/include \
          -DCMAKE_LIBRARY_PATH=$SAGE_LOCAL/lib \
          -DCMAKE_INSTALL_PREFIX=$SAGE_LOCAL \
	  -DBoost_NO_BOOST_CMAKE=ON \
	  -DBoost_LIBRARY_DIRS=$SAGE_LOCAL/lib \
          -DDISABLE_GUI=1 -DREGINA_INSTALL_TYPE=XDG ..
    make -j$N_CORES install
    cd ../..
}

#build_jansson
build_boost
build_tokyocabinet
build_regina
