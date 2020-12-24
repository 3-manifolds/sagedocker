set -e  # exit when any command fails
sage -pip install FXrays
sage -pip install git+https://github.com/3-manifolds/plink.git
sage -pip install git+https://github.com/3-manifolds/snappy_manifolds.git
sage -pip install git+https://github.com/3-manifolds/snappy_15_knots.git
sage -pip install git+https://github.com/3-manifolds/spherogram.git
sage -pip install git+https://github.com/3-manifolds/snappy.git
sage -pip install git+https://github.com/3-manifolds/pe.git
sage -pip install git+https://github.com/3-manifolds/gridlink.git
sage -pip install flipper
sage -pip install curver
sage -python -m snappy.test
