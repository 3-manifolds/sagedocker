# Some standard Python packages
sage -pip install --upgrade "pip>10" setuptools virtualenv wheel
# The following two packages should be pulled in automatically by
# pillow and sphinx, respectively, but aren't for whatever reason.
sage -pip install olefile sphinxcontrib-websupport
sage -pip install mercurial mysql-python sqlalchemy pycosat
sage -pip install --upgrade --no-binary :all: \
     --no-build-isolation \
     pandas matplotlib jupyterlab
# This next mess is to make interactive plotting work with jupyterlab
# We get a bleeding edge ipympl to get rid of some DeprecationWarnings,
# see https://github.com/matplotlib/jupyter-matplotlib/issues/51
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
sage -pip install git+https://github.com/matplotlib/jupyter-matplotlib
/sage/local/bin/jupyter-labextension install @jupyter-widgets/jupyterlab-manager
