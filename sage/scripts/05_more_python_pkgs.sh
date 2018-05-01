# Some standard Python packages
sage -pip install --upgrade "pip>10" setuptools virtualenv wheel
# The following two packages should be pulled in automatically by
# pillow and sphinx, respectively, but aren't for whatever reason.
sage -pip install olefile sphinxcontrib-websupport
sage -pip install mercurial mysql-python sqlalchemy pycosat
sage -pip install --upgrade --no-binary :all: \
     --no-build-isolation \
     pandas matplotlib jupyterlab
