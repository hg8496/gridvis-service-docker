FROM alpine:3.9 AS builder

ENV HOME /root
ENV VERSION 7.3.123

COPY response.varfile /response.varfile

RUN apk add --no-cache openjdk8-jre fontconfig ttf-ubuntu-font-family wget gzip bash
RUN wget -q -O hub.sh http://gridvis.janitza.de/download/${VERSION}/hub-${VERSION}-unix.sh
RUN sh hub.sh -q -varfile /response.varfile

FROM balenalib/armv7hf-alpine-openjdk:8--3.9-run

COPY --from=builder /usr/local/GridVisHub /usr/local/GridVisHub

RUN [ "cross-build-start" ]
RUN apk add --no-cache fontconfig ttf-ubuntu-font-family bash
RUN mkdir -p /opt/GridVisHubData \
    && mkdir -p /opt/GridVisProjects \
    && ln -s /opt/GridVisHubData/security.properties /opt/security.properties \
    && sed -i 's#default_userdir.*$#default_userdir=/opt/GridVisHubData#' /usr/local/GridVisHub/etc/hub.conf \
    && addgroup -S gridvis \
    && adduser -S  gridvis gridvis \
    && chown gridvis:gridvis /opt/GridVisHubData /opt/GridVisProjects

ENV USER_TIMEZONE UTC
ENV USER_LANG en
ENV FEATURE_TOGGLES NONE
ENV LANG=en_US.UTF-8

VOLUME ["/opt/GridVisData", "/opt/GridVisProjects"]
COPY gridvis-hub.sh /gridvis-hub.sh

EXPOSE 8080

RUN [ "cross-build-end" ]

USER gridvis
CMD ["/gridvis-hub.sh"]

