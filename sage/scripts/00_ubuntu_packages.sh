# Install the Ubuntu packages that will be needed to build all the
# software.
#
# After making sure everything is up to date, install the basics.

set -e  # exit when any command fails
export DEBIAN_FRONTEND=noninteractive
apt-get -qq -y update
apt-get -qq -y upgrade
# apt-get -q -y install software-properties-common build-essential

# Now install the gcc we actually want to use.  We need Fortran for
# SageMath and Ada for PHCPack
apt-get -q -y install gfortran gnat

# Here is the rest of what is needed or recommended for SageMath
apt-get -q -y install wget automake bzip2 xz-utils make patch curl sudo libssl-dev git libzmq3-dev

# Needed for Regina
apt-get -q -y install cmake libxml2-dev libpopt-dev libjansson-dev libtokyocabinet-dev 

# We install Tk and hence all of X11.
apt-get -q -y install tk

# Scraps.
apt-get -q -y install nano libmysqlclient-dev graphviz-dev
apt-get -q -y install net-tools man psmisc screen time redis-tools cloc 

# Remove some unused packages to save a little space. 
# apt-get -y autoremove
# apt-get clean
rm -rf /var/lib/apt/lists/*

			  
