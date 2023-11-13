FROM debian:bookworm-slim

WORKDIR /opt

RUN usermod -u 99 nobody

# Make directories
RUN mkdir -p /etc/openvpn/configs 
RUN mkdir -p /etc/squid

# Install dependencies
RUN apt update \
    && apt install -y --no-install-recommends \
    curl \
    ca-certificates \
    dnsutils \
    inetutils-ping \
    ipcalc \
    iproute2 \
    iptables \
    kmod \
    moreutils \
    net-tools \
    openresolv \
    openvpn \
    procps \
    squid \
    tzdata \
    unzip \
    && apt-get clean \
    && apt --purge autoremove -y \
    && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

RUN rm -rf /etc/openvpn/*
RUN rm -rf /etc/squid/*

# Configs
ADD openvpn/ /etc/openvpn/
ADD squid/ /etc/squid/

# Download PIA OpenVPN Configs
RUN curl https://www.privateinternetaccess.com/openvpn/openvpn.zip --output /tmp/configs.zip && unzip /tmp/configs.zip -d /etc/openvpn/configs && rm /tmp/configs.zip

# Runners
RUN chmod +x /etc/openvpn/*.sh
RUN chmod +x /etc/squid/*.sh

EXPOSE 8080

CMD ["/bin/bash", "/etc/openvpn/start.sh"]
