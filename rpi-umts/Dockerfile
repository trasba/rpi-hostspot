FROM ubuntu:16.04
MAINTAINER trasba

RUN apt-get -q update && \
    apt-get install -y \
    wget \
    ppp \
    bzip2 \
    net-tools \
    usbutils \
    python \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
    
# if the file is in the local folder you can use
#ADD umtskeeper.tar.gz /opt/umtskeeper/
ADD http://mintakaconciencia.net/squares/umtskeeper/src/umtskeeper.tar.gz /opt/umtskeeper/
RUN cd /opt/umtskeeper \
    && tar -xzf umtskeeper.tar.gz \
    && rm umtskeeper.tar.gz
WORKDIR /opt/umtskeeper
CMD ["/bin/bash"]
