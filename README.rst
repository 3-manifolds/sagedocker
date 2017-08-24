SageMath Docker Image
=====================

This is an attempt to standardize and streamline my computational work
via a custom Docker image that is based around Ubuntu 16.04 LTS and
the latest and greatest SageMath. It is indirectly derived from the
official ``sagemath/sagemath`` Docker image, but includes `SnapPy
<https://bitbucket.org/t3m/snappy>`_, and the Python interfaces to
`Regina <https://regina-normal.github.io/>`_, and `PHCPack
<http://homepages.math.uic.edu/~jan/>`_.

A container instance of this image starts a shell as the user ``sage``
with all the environment variables set as if you had executed ``sage
-sh``.  In particular, ``python`` is SageMath's Python.

This image takes a long time to build, even on a fast computer, since
it compiles SageMath from source, and weighs in at just under 4GB (1GB
compressed). I recommend you use the `posted image
<https://hub.docker.com/r/nathandunfield/sage/>` on DockerHub::

  docker pull nathandunfield/sage
  docker run -i -t nathandunfield/sage

Other uses
==========

SageMath and all the extras are installed in ``/sage``.  You can make
a tarball of that and copy it over to another Ubuntu 16.04 machine.
You will need to have certain system packages installed for this to
work.  Those `listed here
<https://bitbucket.org/nathan_dunfield/sagedocker/src/tip/sage/scripts/00_ubuntu_packages.sh>`_
are certainly enough, though surely one could get by with much less.
  
Building
========

To build from scratch, which takes 1.3 hours using all 8 cores on a Mac
Pro::

  docker build --tag=nathandunfield/sage sage

Put out on DockerHub::

  docker push nathandunfield/sage
