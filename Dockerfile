FROM ubuntu:14.04
MAINTAINER Christian Stolz <hg8496@cstolz.de>

ENV HOME /root

ENV VERSION 7.0.0-m2

RUN cat /tmp/your_key.pub >> /root/.ssh/authorized_keys \
    && rm -f /tmp/your_key.pub \
    && apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install -y wget \
    && wget -q -O service.sh http://gridvis.janitza.de/download/$VERSION/GridVis-Service-$VERSION-64bit.sh \
    && sh service.sh -q \
    && rm service.sh \
    && ln -s /opt/GridVisData/license2.lic /usr/local/GridVisService/license2.lic \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME ["/opt/GridVisData", "/opt/GridVisProjects"]
ADD gridvis-service.sh /gridvis-service.sh
EXPOSE 8080
CMD ["/gridvis-service.sh"]

