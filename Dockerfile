FROM ubuntu:18.04

ENV HOME /root

ENV VERSION 8.0.48

COPY response.varfile /response.varfile
RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y wget openjdk-8-jre fontconfig ttf-ubuntu-font-family \
    && wget -q -O service.sh https://gridvis.janitza.de/download/$VERSION/GridVis-Service-$VERSION-unix.sh \
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
