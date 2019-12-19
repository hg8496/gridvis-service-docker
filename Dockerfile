FROM ubuntu:14.04

ENV HOME /root

ENV VERSION 7.4.41

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y wget \
    && wget -q -O service.sh http://gridvis.janitza.de/download/$VERSION/GridVis-Service-$VERSION-64bit.sh \
    && sh service.sh -q \
    && rm service.sh \
    && ln -s /opt/GridVisData/security.properties /opt/security.properties \
    && ln -s /opt/GridVisData/license2.lic /usr/local/GridVisService/license2.lic \
    && chmod -R a-w /usr/local/GridVisService \
    && apt-get clean \
    && echo "gridvis ALL=NOPASSWD: /usr/local/bin/own-volume" >> /etc/sudoers \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV USER_TIMEZONE UTC
ENV USER_LANG en
ENV FEATURE_TOGGLES NONE
ENV FILE_ENCODING UTF-8

VOLUME ["/opt/GridVisData", "/opt/GridVisProjects"]
COPY gridvis-service.sh /gridvis-service.sh
COPY own-volume.sh /usr/local/bin/own-volume

EXPOSE 8080
USER gridvis
CMD ["/gridvis-service.sh"]
