FROM ubuntu:18.04
LABEL maintainer="Nathan Dunfield <nathan@dunfield.info>"

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -qq -y update && \
    apt-get -qq -y upgrade && \
    apt-get -q -y install xpra && \
    apt-get -q -y install websockify && \
    apt-get -q -y install xterm  && \ 
    apt-get -q -y install nano build-essential sudo

RUN apt-get -q -y install python-tk python-pip
RUN python -m pip install snappy

RUN  adduser --quiet --shell /bin/bash --gecos "Sage user,101,," \
               --disabled-password sage \
     && chown -R sage:sage /home/sage/ \
     && echo "sage ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/01-sage \
     && chmod 0440 /etc/sudoers.d/01-sage

USER sage
WORKDIR /home/sage
CMD ["/bin/bash"]

# docker run -it -p 127.0.0.1:10000:10000 xpra
# xpra start --start-child=xterm --bind-tcp=0.0.0.0:10000
# xpra attach --dpi=90 tcp:127.0.0.1:10000