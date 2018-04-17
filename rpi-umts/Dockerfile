FROM ubuntu:16.04
RUN apt-get -q update && \
    apt-get install -y wget \
    ppp \
    bzip2 \
    net-tools \
    usbutils \
    python \
    && rm -rf /var/lib/apt/lists/*
    
# if the file is in the local folder you can use
#ADD umtskeeper.tar.gz /opt/umtskeeper/
ADD http://mintakaconciencia.net/squares/umtskeeper/src/umtskeeper.tar.gz /opt/umtskeeper/
WORKDIR /opt/umtskeeper
CMD ["/bin/bash"]
