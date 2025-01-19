# Clean up artifacts from the sage build that we don't need for runtime or
# running the tests
#
# For the 'develop' image we leave everything as it would be after a
# successful sage build

cd /sage
if [ "$BRANCH" != "develop" ]; then
    echo "Remove build dir"
    rm -rf build/
    echo "Removing pyc files and Cython garbage"
    (cd src && \
     rm -rf c_lib .cython_version cython_debug; \
     rm -rf build; find . -name '*.pyc' | xargs rm -f; \
     rm -f $(find . -name "*.pyx" | sed 's/\(.*\)[.]pyx$$/\1.c \1.cpp/'); \
     rm -rf sage/ext/interpreters)
    echo "Stripping binaries ..."
    LC_ALL=C find local/lib local/bin local/var/lib/sage/venv-python* -type f -exec strip '{}' ';' 2>&1 | grep -i -v "File format not recognized" |  grep -i -v "File truncated" || true
    echo "Removing sphinx artifacts..."
    rm -rf local/share/doc/sage/doctrees local/share/doc/sage/inventory
    echo "Removing documentation. Inspection in IPython still works."
    rm -rf local/share/doc local/share/*/doc local/share/*/examples local/share/singular/html
    rm -rf upstream
    rm -rf .git
    rm -rf /tmp/tarballs/sage.tar.gz
fi

# Setup all the paths and the ".sage" directory for the sage user.
echo exit | sudo -H -E -u sage /sage/sage


SAGE_VENV=$(/usr/bin/sage -python -c 'import os; print(os.environ["SAGE_VENV"])')

# Alias "python" to "python3"

sudo -H -E -u sage ln -s $SAGE_VENV/bin/python3 $SAGE_VENV/bin/python

# Make SAGE_LOCAL everyones default environment
echo "export SAGE_ROOT=/sage" >> /sage/activate
echo "export SAGE_VENV=$SAGE_VENV" >> /sage/activate
echo ". \$SAGE_VENV/bin/sage-env-config" >> /sage/activate
echo ". \$SAGE_VENV/bin/sage-env" >> /sage/activate
echo ". /sage/activate" >> ~root/.bashrc
echo ". /sage/activate" >> ~sage/.bashrc

