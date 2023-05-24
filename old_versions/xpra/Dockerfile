# Dockerizing is great, but it does disable the graphical features of
# SnapPy.  Here is a way to get them back, after a fashion, using Xpra.
#
# Start container:
#
#   docker run -it -p 127.0.0.1:14500:14500 xpra
#
# On container do:
#
#   xpra start --bind-tcp=0.0.0.0:14500 --dpi=75; export DISPLAY=:0
#
# This will appear to hang the system, but just hit return to get the
# prompt back.  Then start SnapPy:
#
#   SnapPy
#
# Now outside Docker, just point your usual web browser to:
#
#   http://localhost:14500
#
# You should see the main SnapPy terminal window and you can go do
# town.  Performance isn't great, especially for 3D graphics.  You
# can improve this by installing an actual Xpra client on the host
# system:
#
#   https://xpra.org/trac/wiki/Download
#
# For macOS 10.12, you want version 2.3.4 as newer versions seem
# buggy.
#
# Font and UI sizing issues are common outside the HTML5 client,
# especially on high DPI displays.

FROM ubuntu:18.04
LABEL maintainer="Nathan Dunfield <nathan@dunfield.info>"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq -y update && \
    apt-get -qq -y upgrade && \
    apt-get -q -y install websockify xterm  && \
    apt-get -q -y install nano build-essential software-properties-common sudo && \
    apt-get -q -y install python-tk python-pip xvfb less telnet
RUN python -m pip install snappy

RUN  adduser --quiet --shell /bin/bash --gecos "Sage user,101,," \
               --disabled-password sage \
     && chown -R sage:sage /home/sage/ \
     && echo "sage ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/01-sage \
     && chmod 0440 /etc/sudoers.d/01-sage

# Install most current Xpra
COPY xpra-gpg.asc /tmp
RUN apt-key add /tmp/xpra-gpg.asc
RUN echo "deb http://xpra.org/ bionic main" > /etc/apt/sources.list.d/xpra.list;
RUN add-apt-repository universe
RUN apt-get update
RUN apt-get install xpra -y
RUN apt-get -y install rsyslog

# Install ssh as well, though the service won't be turned on by default.
# Compare https://docs.docker.com/engine/examples/running_ssh_service/
#
# RUN apt-get install -y openssh-server
# RUN echo 'sage:stupid' | chpasswd
# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# RUN mkdir /var/run/sshd

USER sage
WORKDIR /home/sage
RUN mkdir .xdg_runtime && \
    chmod 700 .xdg_runtime/
ENV XDG_RUNTIME_DIR=/home/sage/.xdg_runtime

CMD ["/bin/bash"]