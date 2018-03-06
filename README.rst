SageMath Docker Image
=====================

This is an attempt to standardize and streamline computational work
that combines SnapPy, SageMath, and friends via a custom `Docker
<http://www.docker.com>`_ image that is based around Ubuntu 16.04 LTS
and the latest and greatest `SageMath <http://sagemath.org>`_. It is
indirectly derived from the official ``sagemath/sagemath`` Docker
image, but includes `SnapPy <http://bitbucket.org/t3m/snappy>`_, and
the Python interfaces to `Regina <http://regina-normal.github.io/>`_,
and `PHCPack <http://homepages.math.uic.edu/~jan/>`_.

A container instance of this image starts a shell as the user ``sage``
with all the environment variables set as if you had executed ``sage
-sh``.  In particular, ``python`` is SageMath's Python.

This image takes a long time to build, even on a fast computer, since
it compiles SageMath from source, and weighs in at just under 4GB (1GB
compressed). We recommend you use the `posted image
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

  docker run -it -p 8888:8888 computop/sage

and in said container type::

  sage --notebook

and then point your computer's web browser to
``http://localhost:8888``.

Other uses
==========

SageMath and all the extras are installed in ``/sage``.  You can make
a tarball of that and copy it over to another Ubuntu 16.04 machine.
You will need to have certain system packages installed for this to
work.  Those `listed here
<https://bitbucket.org/t3m/sagedocker/src/tip/sage/scripts/00_ubuntu_packages.sh>`_
are certainly enough, though surely one could get by with much less.

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

Building
========

To build from scratch, which takes 1.3 hours using all 8 cores on a Mac
Pro::

  docker build --tag=computop/sage sage

If compiling Sage fails, make sure the Docker application is
configured so that it can use at least 4GB of memory.

Put out on DockerHub::

  docker push computop/sage
