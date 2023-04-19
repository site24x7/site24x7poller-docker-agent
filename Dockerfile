FROM ubuntu

LABEL maintainer="site24x7<support@site24x7.com>>"

WORKDIR /opt

ENV CONTAINER_ENV=true

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y wget && \
    apt-get install --no-install-recommends -y vim && \
    apt-get install --no-install-recommends -y unzip && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install --no-install-recommends -y iputils-ping && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ["s247poller_setup.sh", "/opt/"]

RUN chmod +x s247poller_setup.sh

ENTRYPOINT ["/opt/s247poller_setup.sh"]