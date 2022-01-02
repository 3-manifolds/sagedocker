# USAGE: /bin/bash this_script.sh SAGE_ROOT_DIR TARBALL_DIR

set -e  # exit when any command fails

export SAGE_ROOT=$1
export TARBALL_DIR=$2
. $SAGE_ROOT/activate

N_CORES=$(python -c 'import multiprocessing as mp; print(mp.cpu_count())')

echo "Sage local: $SAGE_LOCAL"
echo "Sage venv: $SAGE_VENV"
echo "Cores: $N_CORES"
echo "$PATH"



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
    cd PHC_src
    patch -p1 --input ../PHC.patch
    cd src/Objects
    make -f makefile_unix phcpy2c3.so
    cd ../Python/PHCpy3
    sage -pip install .
    echo -e "n\nn\nn\n" | python examples/appolonius.py
    cd /tmp/scripts
}

build_qd
build_phc
