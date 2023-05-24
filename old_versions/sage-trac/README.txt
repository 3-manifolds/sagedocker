Typical usage
=============

First, edit the Dockerfile to select the appropriate version of the
SageMath image based on::

  https://hub.docker.com/r/sagemath/sagemath-dev/tags

Then build this image and start a container::

  docker build --tag=sage-trac sage-trac/
  docker run -it sage-trac

In the container, first setup the account::

  git trac config --user dunfield --pass SECRET_PASSWORD
  git config --global user.email "nathan@dunfield.info"
  git config --global user.name "Nathan Dunfield"

Now fetch a ticket and build Sage following::

  http://doc.sagemath.org/html/en/developer/advanced_git.html#merge-in-the-latest-sagemath-version
  
  
