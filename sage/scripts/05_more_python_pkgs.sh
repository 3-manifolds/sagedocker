# Some standard Python packages
sage -pip install --upgrade "pip>10" setuptools virtualenv wheel
sage -pip install olefile # Needed by pillow but not pulled in automatically
sage -pip install mercurial mysql-python sqlalchemy pycosat
sage -pip install --upgrade --no-binary :all: \
     --no-build-isolation \
     pandas matplotlib jupyterlab
