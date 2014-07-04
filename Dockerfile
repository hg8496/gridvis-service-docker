FROM      ubuntu
MAINTAINER Christian Stolz <hg8496@cstolz.de>

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y wget
RUN wget -O service.sh http://gridvis.janitza.de/download/5.0.2/GridVis-Service-5.0.2-64bit.sh && sh service.sh -q && rm service.sh && ln -s /opt/GridVisData/license2.lic /usr/local/GridVisService/license2.lic

VOLUME ["/opt/GridVisData/", "/opt/GridVisProjects"]

EXPOSE 8080
CMD /usr/local/GridVisService/bin/server

