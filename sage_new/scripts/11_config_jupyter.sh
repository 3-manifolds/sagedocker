# USAGE: /bin/bash config_jupyter.sh
set -e  # exit when any command fails

. /home/sage/sage/activate

# JupyterLab: can't do on one line as ipympl chokes without jupyter_packaging
#sage -pip install --no-cache-dir --upgrade jupyter_client jupyter_core jupyter-events \
#     jupyter-lsp jupyter_packaging jupyter_server jupyter_server_terminals \
#     jupyter-sphinx jupyterlab jupyterlab_mathjax2 jupyterlab-pygments jupyterlab_server \
#     jupyterlab-widgets notebook notebook_shim
#sage -pip install --no-cache-dir jupyter_packaging


#sage -pip install --no-cache-dir ipympl

#cat jupyter_notebook_config.py >> \
#    $SAGE_VENV/etc/jupyter/jupyter_notebook_config.py

#cat jupyter_lab_config.py >> \
#    $SAGE_VENV/etc/jupyter/jupyter_lab_config.py

# patch $SAGE_ROOT/src/bin/sage-notebook sage-notebook.patch
