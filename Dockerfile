FROM ubuntu:20.04

ENV HOME /root

ENV VERSION 7.5.65

COPY response.varfile /response.varfile
RUN useradd -r gridvis -u 101 && apt update && apt -y install openjdk-8-jre fontconfig ttf-ubuntu-font-family wget gzip bash xvfb && rm -rf /var/lib/apt/lists/*
RUN wget -q -O service.sh https://gridvis.janitza.de/download/${VERSION}/GridVis-Service-${VERSION}-unix.sh \
    && sh service.sh -q -varfile /response.varfile \
    && rm service.sh \
    && ln -s /opt/GridVisData/security.properties /opt/security.properties \
    && ln -s /opt/GridVisData/license2.lic /usr/local/GridVisService/license2.lic \
    && sed -i 's#default_userdir.*$#default_userdir=/opt/GridVisData#' /usr/local/GridVisService/etc/server.conf

ENV USER_TIMEZONE UTC
ENV USER_LANG en
ENV FEATURE_TOGGLES NONE
ENV START_PARAMS NONE

VOLUME ["/opt/GridVisData", "/opt/GridVisProjects"]
COPY gridvis-service.sh /gridvis-service.sh

EXPOSE 8080
USER gridvis
CMD ["/gridvis-service.sh"]
