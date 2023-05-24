# Install the Ubuntu packages that will be needed to build all the
# software.
#
# After making sure everything is up to date, install the basics.

export DEBIAN_FRONTEND=noninteractive
apt-get -qq -y update
apt-get -qq -y upgrade
apt-get -q -y install python software-properties-common build-essential

# Add a PPA so that we can get newer versions of gcc. Not needed for 18.04.
add-apt-repository ppa:ubuntu-toolchain-r/test -y
apt-get -qq -y update

# Now install the gcc we actually want to use.  We need Fortran for
# SageMath and Ada for PHCPack
apt-get -q -y install gcc-7 g++-7 gfortran-7 gnat-7

# Here is the rest of what is needed for SageMath
apt-get -q -y install wget automake bzip2 xz-utils make patch curl sudo libssl-dev git

# Needed for Regina
apt-get -q -y install cmake libxml2-dev libpopt-dev libjansson-dev

# Scraps, including Tk for now. 
apt-get -q -y install libmysqlclient-dev tk tk-dev nano net-tools man psmisc screen time

# Remove some unused packages to save a little space. 
apt-get -q -y remove python3 gcc-5
apt-get -y autoremove
apt-get clean
rm -rf /var/lib/apt/lists/*

# Make gcc 7 and friends the default.  For 18.04 this is not needed since it is
# already the default.
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 100 \
		    --slave /usr/bin/g++ g++ /usr/bin/g++-7  \
                    --slave /usr/bin/gfortran gfortran /usr/bin/gfortran-7  \
		    --slave /usr/bin/gnat gnat /usr/bin/gnat-7
			  
