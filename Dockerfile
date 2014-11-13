FROM phusion/baseimage:0.9.15
MAINTAINER Christian Stolz <hg8496@cstolz.de>

ENV HOME /root
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD ["/sbin/my_init"]

ADD keys.pub /tmp/your_key.pub
RUN cat /tmp/your_key.pub >> /root/.ssh/authorized_keys && rm -f /tmp/your_key.pub

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get install -y wget
RUN wget -q -O service.sh http://gridvis.janitza.de/download/5.1.0/GridVis-Service-5.1.0-64bit.sh && sh service.sh -q && rm service.sh && ln -s /opt/GridVisData/license2.lic /usr/local/GridVisService/license2.lic 

VOLUME ["/opt/GridVisData", "/opt/GridVisProjects"]
ADD gridvis-service.sh /etc/service/gridvis-service/run
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
EXPOSE 8080 22

