FROM ubuntu

LABEL maintainer="site24x7<support@site24x7.com>>"

WORKDIR /opt

ENV IS_CONTAINER_ENV=true

RUN apt-get update -y && \
    apt-get install -y wget && \
    apt-get install -y vim && \
    apt-get install -y unzip && \
    apt-get install -y curl && \
    apt-get install -y iputils-ping && \
    wget -O Site24x7OnPremisePoller_64bit.bin https://staticdownloads.site24x7.com/probe/Site24x7OnPremisePoller_64bit.bin && \
	wget -O Networkplus_lin.zip https://staticdownloads.site24x7.com/network/Networkplus_lin.zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ["s247poller_setup.sh", "/opt/"]

RUN chmod +x s247poller_setup.sh

ENTRYPOINT ["/opt/s247poller_setup.sh"]
