FROM ubuntu:16.04
MAINTAINER trasba

RUN apt-get update && \
    apt-get install -y \
    hostapd \
    dnsmasq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
