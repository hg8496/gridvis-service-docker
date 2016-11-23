FROM alpine:3.4
MAINTAINER Christian Stolz <hg8496@cstolz.de>

ENV HOME /root

ENV VERSION 7.1.6-m5

COPY response.varfile /response.varfile
RUN apk add --no-cache openjdk8-jre fontconfig ttf-ubuntu-font-family wget gzip
RUN wget -q -O service.sh http://gridvis.janitza.de/download/$VERSION/GridVis-Service-$VERSION-unix.sh \
    && sh service.sh -q -varfile /response.varfile \
    && rm service.sh \
    && mkdir /opt \
    && ln -s /opt/GridVisData/security.properties /opt/security.properties \
    && sed -i 's#default_userdir.*$#default_userdir=/opt/GridVisData#' /usr/local/GridVisService/etc/server.conf \
    && adduser -S  gridvis gridvis \
    && chmod -R a-w /usr/local/GridVisService \
    && echo "gridvis ALL=NOPASSWD: /usr/local/bin/own-volume" >> /etc/sudoers

ENV USER_TIMEZONE UTC
ENV USER_LANG en
ENV FEATURE_TOGGLES NONE

VOLUME ["/opt/GridVisData", "/opt/GridVisProjects"]
ADD gridvis-service.sh /gridvis-service.sh
ADD own-volume.sh /usr/local/bin/own-volume

EXPOSE 8080
USER gridvis
CMD ["/gridvis-service.sh"]
