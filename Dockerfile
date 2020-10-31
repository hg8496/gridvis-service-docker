FROM alpine:3.11

ENV HOME /root

ENV VERSION 7.5.23

COPY response.varfile /response.varfile
RUN apk add --no-cache openjdk8-jre fontconfig ttf-ubuntu-font-family wget gzip bash
RUN wget -q -O service.sh http://gridvis.janitza.de/download/${VERSION}/GridVis-Service-${VERSION}-unix.sh \
    && sh service.sh -q -varfile /response.varfile \
    && rm service.sh \
    && ln -s /opt/GridVisData/security.properties /opt/security.properties \
    && ln -s /opt/GridVisData/license2.lic /usr/local/GridVisService/license2.lic \
    && sed -i 's#default_userdir.*$#default_userdir=/opt/GridVisData#' /usr/local/GridVisService/etc/server.conf \
    && addgroup -S gridvis \
    && addgroup -S  gridvis gridvis

ENV USER_TIMEZONE UTC
ENV USER_LANG en
ENV FEATURE_TOGGLES NONE

VOLUME ["/opt/GridVisData", "/opt/GridVisProjects"]
COPY gridvis-service.sh /gridvis-service.sh

EXPOSE 8080
USER gridvis
CMD ["/gridvis-service.sh"]
