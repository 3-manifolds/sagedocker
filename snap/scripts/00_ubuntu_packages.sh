# Install the Ubuntu packages that will be needed to build all the
# software.
#
# After making sure everything is up to date, install the basics.

export DEBIAN_FRONTEND=noninteractive
apt-get -qq -y update
apt-get -qq -y upgrade
apt-get -q -y install software-properties-common build-essential
apt-get -q -y install gcc-7 g++-7

# Here is the rest of what is needed for SageMath
apt-get -q -y install wget automake bzip2 xz-utils make patch curl sudo 
