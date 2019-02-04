# USAGE: /bin/bash this_script.sh SAGE_ROOT_DIR TARBALL_DIR

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
    tar xfz $TARBALL_DIR/$1.tar.gz --directory=$dir --strip-components=1
}

build_qd ()
{
    unpack_source qd
    cd qd_src
    ./configure --prefix=$SAGE_LOCAL CXX=/usr/bin/g++ CXXFLAGS="-fPIC -O3"
    make -j$N_CORES install
    cd ..    
}

build_phc ()
{
    unpack_source PHC
    cd PHC_src/src/Objects
    patch --input /tmp/scripts/makefile_unix.patch makefile_unix
    make -f makefile_unix phcpy2c2.so
    make -f makefile_unix phcpy2c3.so
    cd ../Python/PHCpy2
    python2 -m pip install .
    echo -e "n\nn\nn\n" | python2 examples/appolonius.py
    cd ../PHCpy3/
    python3 -m pip install .
    echo -e "n\nn\nn\n" | python3 examples/appolonius.py 
    cd /tmp/scripts
}

build_qd
build_phc
