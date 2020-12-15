# Some standard Python packages
set -e  # exit when any command fails
sage -pip install --upgrade "pip>10" setuptools virtualenv wheel
# The following two packages should be pulled in automatically by
# pillow and sphinx, respectively, but aren't for whatever reason.
sage -pip install olefile sphinxcontrib-websupport
sage -pip install mysqlclient sqlalchemy pycosat
sage -pip install pygraphviz

# In Sage 9.1 the version of Cython is too old to build Pandas, so we
# upgrade.
sage -pip install --upgrade cython
sage -pip install --upgrade --no-binary :all: \
     --no-build-isolation \
     pandas matplotlib jupyterlab
# This next mess is to make interactive plotting work with jupyterlab
# Note: The next release of JupyterLab will need to be run in Python 3.
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
sage -pip install -U subprocess32 ipympl
/sage/local/bin/jupyter labextension install @jupyter-widgets/jupyterlab-manager
