FROM ubuntu:16.04
MAINTAINER trasba

RUN apt-get update && \
    apt-get install -y \
    hostapd \
    dnsmasq \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && echo "RUN_DAEMON=\"yes\"\nDAEMON_CONF=\"/etc/hostapd/hostapd.conf\"" >> /etc/default/hostapd
