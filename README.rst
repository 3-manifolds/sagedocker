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
it compiles SageMath from source.
