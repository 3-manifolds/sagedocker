set -e  # exit when any command fails
# sage -pip --no-cache-dir install FXrays cypari sphinx_rtd_theme
# sage -pip --no-cache-dir install git+https://github.com/3-manifolds/plink.git
# sage -pip --no-cache-dir install git+https://github.com/3-manifolds/low_index.git
# sage -pip --no-cache-dir install git+https://github.com/3-manifolds/snappy_manifolds.git
# sage -pip --no-cache-dir install git+https://github.com/3-manifolds/snappy_15_knots.git
sage -pip --no-cache-dir install git+https://github.com/3-manifolds/spherogram.git
sage -pip --no-cache-dir install git+https://github.com/3-manifolds/snappy.git
sage -pip --no-cache-dir install snappy snappy_15_knots
sage -pip --no-cache-dir install git+https://github.com/3-manifolds/pe.git
sage -pip --no-cache-dir install git+https://github.com/3-manifolds/gridlink.git
sage -pip --no-cache-dir install flipper
sage -pip --no-cache-dir install curver
sage -python -m snappy.test
# Test regina_dreamteam + snappy
sage -python test_more_cusps.py 
