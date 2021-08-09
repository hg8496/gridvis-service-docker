FROM alpine:3.10 AS builder

ENV HOME /root
ENV VERSION 8.0.47

COPY response.varfile /response.varfile

RUN apk add --no-cache openjdk8-jre fontconfig ttf-ubuntu-font-family wget gzip bash
RUN wget -q -O hub.sh https://gridvis.janitza.de/download/${VERSION}/GridVis-Hub-${VERSION}-unix.sh
RUN sh hub.sh -q -varfile /response.varfile

FROM balenalib/armv7hf-ubuntu-openjdk:8

COPY --from=builder /usr/local/GridVisHub /usr/local/GridVisHub

RUN [ "cross-build-start" ]
RUN install_packages fontconfig ttf-ubuntu-font-family bash
RUN mkdir -p /opt/GridVisHubData \
    && mkdir -p /opt/GridVisProjects \
    && ln -s /opt/GridVisHubData/security.properties /opt/security.properties \
    && sed -i 's#default_userdir.*$#default_userdir=/opt/GridVisHubData#' /usr/local/GridVisHub/etc/hub.conf \
    && useradd -r gridvis -u 101 \
    && chown gridvis:gridvis /opt/GridVisHubData /opt/GridVisProjects

ENV USER_TIMEZONE UTC
ENV USER_LANG en
ENV FEATURE_TOGGLES NONE
ENV LANG=en_US.UTF-8
ENV HUB_PARAMS NONE

VOLUME ["/opt/GridVisHubData", "/opt/GridVisProjects"]
COPY gridvis-hub.sh /gridvis-hub.sh

EXPOSE 8080

RUN [ "cross-build-end" ]

USER gridvis
CMD ["/gridvis-hub.sh"]

