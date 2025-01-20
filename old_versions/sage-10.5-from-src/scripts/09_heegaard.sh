# Installing Heegaard and the associated Python package
#
# First, setup Sage environment.
set -e  # exit when any command fails
export SAGE_ROOT=$1
. /sage/activate
# Build and install "heegaard" executable in $SAGE_LOCAL/bin.
git clone https://github.com/3-manifolds/heegaard
cd heegaard/src
make heegaard
cp ./heegaard $SAGE_LOCAL/bin
# Build and install Python package
cd ../python
sage -pip install .
sage -python -c "import heegaard; heegaard.is_realizable(['aBAbaabAB', 'aBAbABabbbbbb'])"
# Cleanup
cd ../../
rm -rf heegaard

# Let's do Heegaard3 as well
git clone https://github.com/3-manifolds/heegaard3
cd heegaard3/
make
mv ../heegaard $SAGE_LOCAL/bin/heegaard3
cd ../
rm -rf heegaard3
