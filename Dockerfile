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
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ["s247poller_setup.sh", "/opt/"]

RUN chmod +x s247poller_setup.sh

ENTRYPOINT ["/opt/s247poller_setup.sh"]