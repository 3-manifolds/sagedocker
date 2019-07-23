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

COPY xpra-gpg.asc /tmp
RUN apt-key add /tmp/xpra-gpg.asc
RUN echo "deb http://xpra.org/ bionic main" > /etc/apt/sources.list.d/xpra.list;
RUN add-apt-repository universe
RUN apt-get update
RUN apt-get install xpra -y
RUN apt-get -y install rsyslog

USER sage
WORKDIR /home/sage
RUN mkdir .xdg_runtime && \
    chmod 700 .xdg_runtime/
ENV XDG_RUNTIME_DIR=/home/sage/.xdg_runtime

CMD ["/bin/bash"]

# Start container
#
# docker run -it -p 127.0.0.1:14500:14500 xpra
#
# On container do
#
# xpra start --bind-tcp=0.0.0.0:14500 --dpi=75; export DISPLAY=:0
#
# Now either point your web browser to
#
# http://localhost:14500
#
# or install the Xpra client
#
# https://xpra.org/trac/wiki/Download
#
#