# Some standard Python packages
set -e  # exit when any command fails
# Make sure packaging toolchain is latest and greatest.
sage -pip install --no-cache-dir --upgrade pip setuptools virtualenv wheel

# The following two packages should be pulled in automatically by
# pillow and sphinx, respectively, but aren't for whatever reason.
sage -pip install --no-cache-dir olefile sphinxcontrib-websupport
export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig
sage -pip install --no-cache-dir mysqlclient sqlalchemy
sage -pip install --no-cache-dir pycosat versioneer
sage -pip install --no-cache-dir pygraphviz
sage -pip install --no-cache-dir --upgrade \
     --no-build-isolation \
     pandas matplotlib

# Just in case
rm -rf /home/sage/.cache
