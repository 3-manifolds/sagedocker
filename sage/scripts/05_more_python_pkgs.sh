# Some standard Python packages
sage -pip install --upgrade pip setuptools virtualenv wheel
sage -pip install mercurial mysql-python sqlalchemy pycosat
sage -pip install --upgrade --no-binary :all: \
     --upgrade-strategy only-if-needed \
     pandas matplotlib
