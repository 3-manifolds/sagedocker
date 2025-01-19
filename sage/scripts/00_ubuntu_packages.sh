# Install the Ubuntu packages that will be needed to build all the
# software.
#
# After making sure everything is up to date, install the basics.

set -e  # exit when any command fails
export DEBIAN_FRONTEND=noninteractive
apt-get -qq -y update
apt-get -qq -y upgrade
apt-get -q -y install software-properties-common build-essential python3-dev

# Now install the gcc we actually want to use.  We need Fortran for
# SageMath and Ada for PHCPack
apt-get -q -y install gfortran gnat

# Here is the rest of what is needed or recommended for SageMath
apt-get -q -y install wget automake bzip2 xz-utils make patch curl sudo libssl-dev git libzmq3-dev
apt-get -q -y install libboost-dev libffi-dev libgd-dev libncurses-dev libpcre3-dev libsqlite3-dev
apt-get -q -y install libtachyon-serial-0-dev tox yasm libcurl4-openssl-dev libatomic-ops-dev
apt-get -q -y install ninja-build pandoc libxml-libxslt-perl libxml-writer-perl libxml2-dev libperl-dev libfile-slurp-perl
apt-get -q -y install libjson-perl libsvg-perl libterm-readkey-perl libterm-readline-gnu-perl libmongodb-perl
apt-get -q -y install libterm-readline-gnu-perl libmongodb-perl libterm-readline-gnu-perl tachyon

# More of the same, copied from https://sagemanifolds.obspm.fr/install_ubuntu.html without removing repeats.
# and with libsingular removed.
#apt-get -q -y install automake bc binutils bzip2 ca-certificates cliquer cmake curl ecl eclib-tools fflas-ffpack flintqs g++ gengetopt gfan gfortran git glpk-utils gmp-ecm lcalc libatomic-ops-dev libboost-dev libbraiding-dev libbz2-dev libcdd-dev libcdd-tools libcliquer-dev libcurl4-openssl-dev libec-dev libecm-dev libffi-dev libflint-dev libfreetype-dev libgc-dev libgd-dev libgf2x-dev libgiac-dev libgivaro-dev libglpk-dev libgmp-dev libgsl-dev libhomfly-dev libiml-dev liblfunction-dev liblrcalc-dev liblzma-dev libm4rie-dev libmpc-dev libmpfi-dev libmpfr-dev libncurses-dev libntl-dev libopenblas-dev libpari-dev libpcre3-dev libplanarity-dev libppl-dev libprimesieve-dev libpython3-dev libqhull-dev libreadline-dev librw-dev libsqlite3-dev libssl-dev libsuitesparse-dev libsymmetrica2-dev zlib1g-dev libzmq3-dev libzn-poly-dev m4 make nauty openssl palp pari-doc pari-elldata pari-galdata pari-galpol pari-gp2c pari-seadata patch perl pkg-config planarity ppl-dev python3-setuptools python3-venv r-base-dev r-cran-lattice sqlite3 sympow tachyon tar tox xcas xz-utils

# The core mathematical components of Sage are built from source
# rather than using system packages to make the result as "stock" as
# possible.  These three are exceptions.
apt-get -q -y install libopenblas-dev r-base-dev r-cran-lattice

# Needed for Regina
apt-get -q -y install cmake libxml2-dev libpopt-dev libjansson-dev libtokyocabinet-dev 

# Scraps, including Tk for now. 
apt-get -q -y install libmysqlclient-dev graphviz-dev python3-tk tk-dev nano
apt-get -q -y install net-tools man psmisc screen time mercurial redis-tools cloc 

# Remove some unused packages to save a little space. 
apt-get -y autoremove
apt-get clean
rm -rf /var/lib/apt/lists/*

			  
