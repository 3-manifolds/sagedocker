# USAGE: /bin/bash config_jupyter.sh
set -e  # exit when any command fails

. /home/sage/sage/activate

# First we overwrite Sage's somewhat shambolic Jupyter setup.
# This also installs jupyter_packaging
sage -pip install --no-cache-dir --requirement modern_jupyter_reqs.txt

# Do this as a separate step, not sure this is necessary any more.
sage -pip install --no-cache-dir ipympl

# Copy in the config files.  Can't put them in
# $SAGE_VENV/share/jupyter because (I think) the json versions there
# take precedence.  In addition to dropping all shields, keeps logging
# messages to an absolute minimum.

mkdir -p /home/sage/.sage/jupyter-4.1
cp jupyter_server_config.py /home/sage/.sage/jupyter-4.1/
cp jupyter_notebook_config.py /home/sage/.sage/jupyter-4.1/

# Patch sage-notebook so that:
#
# a) Prints URL to connect to.
#
# b) Silences all the deprecation warnings between the various Jupyter
#    components.

patch $SAGE_VENV/bin/sage-notebook sage-notebook.patch
