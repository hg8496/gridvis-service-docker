FROM alpine:3.9

ENV HOME /root

ENV VERSION 7.5.64

COPY response.varfile /response.varfile
RUN apk add --no-cache openjdk8-jre fontconfig ttf-ubuntu-font-family wget gzip bash
RUN wget -q -O hub.sh https://gridvis.janitza.de/download/${VERSION}/GridVis-Hub-${VERSION}-unix.sh \
    && sh hub.sh -q -varfile /response.varfile \
    && rm hub.sh \
    && ln -s /opt/GridVisData/security.properties /opt/security.properties \
    && sed -i 's#default_userdir.*$#default_userdir=/opt/GridVisHubData#' /usr/local/GridVisHub/etc/hub.conf \
    && addgroup -S gridvis \
    && addgroup -S  gridvis gridvis \
    && mkdir -p /opt/GridVisHubData \
    && mkdir -p /opt/GridVisProjects \
    && chown gridvis:gridvis /opt/GridVis*

ENV USER_TIMEZONE UTC
ENV USER_LANG en
ENV FEATURE_TOGGLES NONE

COPY gridvis-hub.sh /gridvis-hub.sh

USER gridvis
VOLUME ["/opt/GridVisHubData", "/opt/GridVisProjects"]

EXPOSE 8080
CMD ["/gridvis-hub.sh"]
