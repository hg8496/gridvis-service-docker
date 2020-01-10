FROM alpine:3.10 AS builder

ENV HOME /root
ENV VERSION 7.4.42

COPY response.varfile /response.varfile

RUN apk add --no-cache openjdk8-jre fontconfig ttf-ubuntu-font-family wget gzip bash
RUN wget -q -O service.sh http://gridvis.janitza.de/download/${VERSION}/GridVis-Service-${VERSION}-unix.sh
RUN sh service.sh -q -varfile /response.varfile

FROM balenalib/armv7hf-alpine-openjdk:8--3.10-run

COPY --from=builder /usr/local/GridVisService /usr/local/GridVisService

RUN [ "cross-build-start" ]
RUN apk add --no-cache fontconfig ttf-ubuntu-font-family bash
RUN mkdir -p /opt/GridVisData \
    && mkdir -p /opt/GridVisProjects \
    && ln -s /opt/GridVisData/security.properties /opt/security.properties \
    && sed -i 's#default_userdir.*$#default_userdir=/opt/GridVisData#' /usr/local/GridVisService/etc/server.conf \
    && addgroup -S gridvis \
    && adduser -S  gridvis gridvis \
    && chown gridvis:gridvis /opt/GridVisData /opt/GridVisProjects \
    && chmod a-w /usr/local/GridVisService

ENV USER_TIMEZONE UTC
ENV USER_LANG en
ENV FEATURE_TOGGLES NONE
ENV LANG=en_US.UTF-8

VOLUME ["/opt/GridVisData", "/opt/GridVisProjects"]
COPY gridvis-service.sh /gridvis-service.sh

EXPOSE 8080

RUN [ "cross-build-end" ]

USER gridvis
CMD ["/gridvis-service.sh"]

