FROM ghcr.io/pr0fg/pia-docker-base:latest

WORKDIR /opt

# Install dependencies
RUN apt update \
    && apt install -y --no-install-recommends squid \
    && apt-get clean \
    && apt --purge autoremove -y \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# Configs
RUN rm -rf /etc/squid/*
ADD squid/ /etc/squid/

# Entrypoint
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

# Health check env
ENV HEALTHCHECK_PROCESS_NAME=squid

EXPOSE 8080
