# Some standard Python packages
set -e  # exit when any command fails
# Make sure packaging toolchain is latest and greatest.
sage -pip install --no-cache-dir --upgrade pip setuptools virtualenv wheel

# JupyterLab: can't do on one line as ipympl chokes without jupyter_packaging
# sage -pip install --no-cache-dir jupyterlab
# sage -pip install --no-cache-dir jupyter_packaging
# sage -pip install --no-cache-dir ipympl

# The following two packages should be pulled in automatically by
# pillow and sphinx, respectively, but aren't for whatever reason.
sage -pip install --no-cache-dir olefile sphinxcontrib-websupport
sage -pip install --no-cache-dir mysqlclient sqlalchemy pycosat versioneer
sage -pip install --no-cache-dir --upgrade \
     --no-build-isolation \
     pandas matplotlib

# Just in case
rm -rf /home/sage/.cache
