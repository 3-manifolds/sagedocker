SageMath Docker Image
=====================

This is an attempt to standardize and streamline computational work
that combines SnapPy, SageMath, and friends via a custom `Docker
<http://www.docker.com>`_ image that is based around Ubuntu 22.04 LTS
and the latest and greatest `SageMath <http://sagemath.org>`_. It is
directly derived from the official ``sagemath/sagemath`` Docker
image, but includes `SnapPy <http://bitbucket.org/t3m/snappy>`_, and
the Python interfaces to `Regina <http://regina-normal.github.io/>`_,
and `PHCPack <http://homepages.math.uic.edu/~jan/>`_.

A container instance of this image starts a shell as the user ``sage``
with all the environment variables set as if you had executed ``sage
-sh``.

This image takes a long time to build, even on a fast computer, since
it compiles SageMath from source, and weighs in at 5.2 GB (1.6
GB compressed). We recommend you use the `posted image
<http://hub.docker.com/r/computop/sage/>`_ on DockerHub via::

  docker pull computop/sage
  docker run -it computop/sage

Here, the first command downloads the image from DockerHub and the
second starts a container that is running said image.  Moving files
between the container and the rest of the world can be done using
``scp`` or having the container mount a local directory as in this example::

  docker run -it --mount type=bind,source="$HOME/Dropbox/linux_share",target=/home/sage/linux_share computop/sage

where the directory ``linux_share`` inside the user's ``Dropbox`` folder is
shared.

If you want to use Sage's Jupyter notebook interface, start the
container via::

  docker run -it -p 127.0.0.1:8888:8888 computop/sage

and in said container type::

  sage --notebook

and then point your computer's web browser to
``http://localhost:8888``.  As of ``computop/sage:10.5``, this uses
`Notebook 7
<https://jupyter-notebook.readthedocs.io/en/latest/notebook_7_features.html>`_.
If you want interactive plots with MatplotLib, the command is now
``%matplotlib widget`` rather than ``%matplotlib notebook``.

If you want to use `JupyterLab
<https://jupyterlab.readthedocs.io/en/stable/>`_, you can instead do::

   sage --notebook jupyterlab

In JupyterLab, you have access not just to notebooks but also Python
consoles and shell terminal windows.  

Python 2 versus Python 3
========================

The images for SageMath 8.9 and older use Python 2 (and Ubuntu 16.04)
and those for SageMath 9.0 and newer use Python 3 (and Ubuntu 18.04,
20.04, or 22.04).  You can always request Docker run a particular
version of the image, for example if you want SageMath 8.9 do::

  docker run -it computop/sage:8.9

Components
==========

A partial list of included software:

* `SageMath <http://sagemath.org>`_
* `SnapPy <http://snappy.computop.org>`_
* `Regina <http://regina-normal.github.io/>`_
* Two Python interfaces to `PHCPack
  <http://homepages.math.uic.edu/~jan/>`_
* `pandas <http://pandas.pydata.org/>`_
* `pe <http://bitbucket.org/t3m/pe>`_
* `gridlink <http://bitbucket.org/t3m/gridlink>`_
* `flipper <http://flipper.readthedocs.io>`_ and `curver <http://curver.readthedocs.io>`_
* `heegaard <http://bitbucket.org/t3m/heegaard>`_
* `pygraphviz <http://pygraphviz.github.io/>`_
* `snap <http://snap-pari.sourceforge.net>`_

We no longer include `HIKMOT
<http://www.oishi.info.waseda.ac.jp/~takayasu/hikmot/>`_ as it is not
compatible with Python 3.

Building
========

To build from scratch, which takes 1.3 hours using all 8 cores on a Mac
Pro::

  docker build --tag=computop/sage sage

If compiling Sage fails, make sure the Docker application is
configured so that it can use at least 4GB of memory.

Put out on DockerHub::

  docker push computop/sage
