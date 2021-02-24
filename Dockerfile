FROM ubuntu:18.04 AS builder

ENV HOME /root

ENV VERSION 7.5.66-SNAPSHOT

COPY response.varfile /response.varfile
RUN useradd -r gridvis -u 101 && apt update && apt -y install openjdk-8-jre fontconfig ttf-ubuntu-font-family wget gzip bash
RUN wget -q -O service.sh https://gridvis.janitza.de/download/${VERSION}/GridVis-Service-${VERSION}-unix.sh
RUN sh service.sh -q -varfile /response.varfile \
RUN sed -i 's#default_userdir.*$#default_userdir=/opt/GridVisData#' /usr/local/GridVisService/etc/server.conf

FROM ubuntu:18.04
RUN useradd -r gridvis -u 101 && apt update && apt -y install openjdk-8-jre fontconfig ttf-ubuntu-font-family xvfb libgtk-3-0 libxss1 libgbm1 && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/GridVisService /usr/local/GridVisService

RUN ln -s /opt/GridVisData/security.properties /opt/security.properties \
 && ln -s /opt/GridVisData/license2.lic /usr/local/GridVisService/license2.lic

ENV USER_TIMEZONE UTC
ENV USER_LANG en
ENV FEATURE_TOGGLES NONE
ENV START_PARAMS NONE

USER gridvis

VOLUME ["/opt/GridVisData", "/opt/GridVisProjects"]
COPY gridvis-service.sh /gridvis-service.sh

EXPOSE 8080
CMD ["/gridvis-service.sh"]
