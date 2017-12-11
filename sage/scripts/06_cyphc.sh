# USAGE: /bin/bash build_regina.sh SAGE_ROOT_DIR TARBALL_DIR

export SAGE_ROOT=$1
. "$SAGE_ROOT/local/bin/sage-env" >&2 

build_cyphc ()
{
    hg clone https://bitbucket.org/t3m/cyphc
    cd cyphc
    bash getPHC.sh
    python2 make.py
    python2 -m pip install .
    cd ../
    rm -rf cyphc
}

build_cyphc
