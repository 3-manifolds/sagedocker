# Installing Heegaard and the associated Python package
#
# First, setup Sage environment.
export SAGE_ROOT=/sage
. /sage/local/bin/sage-env
# Build and install "heegaard" executable in $SAGE_LOCAL/bin.
hg clone https://bitbucket.org/t3m/heegaard
cd heegaard/src
make heegaard
cp ./heegaard $SAGE_LOCAL/bin
# Build and install Python package
cd ../python
sage -python setup.py pip_install
# Cleanup
cd ../../
rm -rf heegaard
