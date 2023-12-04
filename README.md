# [Squid](https://github.com/squid-cache/squid) HTTP/HTTPS proxy with Private Internet Access (PIA) Integration

Docker container that runs the latest [Squid](https://github.com/squid-cache/squid) HTTP/HTTPS proxy and forwards all requests through Private Internet Access (PIA) via OpenVPN. Supports proxying HTTP and HTTPS connectons **without caching**. Supports both x86 & ARM.

The base image [pia-docker-base](https://github.com/pr0fg/pia-docker-base) is based on Debian bookworm-slim and includes an iptables killswitch, DNS nameserver overrides, and IPv6 blocking to prevent IP leakage when the tunnel goes down. If OpenVPN fails to reconnect or has a fault, the container will automatically kill itself. All permissions are dropped where possible. A healthcheck script is also included that monitors network connectivity and the health of spawned processes.  

# Docker Features
* Base: [pia-docker-base](https://github.com/pr0fg/pia-docker-base) (Debian bookworm-slim, **supports x86 & ARM**)
* [Squid](https://github.com/squid-cache/squid) HTTP/HTTPS proxy **with caching disabled**
* Automatically connects to Private Internet Access (PIA) using OpenVPN
* IP tables killswitch to prevent IP leaking when VPN connection fails
* DNS overrides to avoid DNS leakage
* Blocks IPv6 to avoid leakage
* Drops all permissions where possible
* Auto checks VPN and squid health every 10 seconds, with configurable health checks
* Simplified configuation options

# Pulling the Image
`docker image pull ghcr.io/pr0fg/squid-pia`

# Running via Docker CLI
`docker run -it --rm --cap-add=NET_ADMIN --device=/dev/net/tun --sysctl net.ipv4.conf.all.src_valid_mark=1 -e VPN_REGION=ca_toronto -e VPN_USERNAME=pXXXXXXX -e VPN_PASSWORD=XXXXXXX -e LAN_NETWORK=192.168.1.0/24 -p 8080:8080/tcp squid-pia`

# Running via Docker Compose
```
version: '3'

services:

  squid:
    build: ./squid-pia
    restart: unless-stopped
    environment:
      - TZ=America/Toronto
      - VPN_REGION=${VPN_REGION}
      - VPN_USERNAME=${VPN_USERNAME}
      - VPN_PASSWORD=${VPN_PASSWORD}
      - LAN_NETWORK=${LAN_NETWORK}
      - NAME_SERVERS=
      - HEALTHCHECK_INTERVAL=
      - HEALTHCHECK_DNS_HOST=
      - HEALTHCHECK_PING_IP=
    cap_add:
      - NET_ADMIN
    devices:
      - /dev/net/tun
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    ports:
      - 8080:8080
```

# Variables, Volumes, and Ports
## Environment Variables
| Variable | Required | Function | Example | Default |
|----------|----------|----------|---------|---------|
|`VPN_REGION`| Yes | PIA VPN Region | `VPN_REGION=ca_toronto`||
|`VPN_USERNAME`| Yes | PIA username | `VPN_USERNAME=pXXXXXX`||
|`VPN_PASSWORD`| Yes | PIA password | `VPN_PASSWORD=XXXXXXX`||
|`LAN_NETWORK`| Yes | Local network with CIDR notation | `LAN_NETWORK=192.168.1.0/24`||
|`TZ`| No | Timezone |`TZ=America/Toronto`| System default |
|`NAME_SERVERS`| No | Comma delimited name servers |`NAME_SERVERS=1.1.1.1,1.0.0.1`| 1.1.1.1,8.8.8.8,1.0.0.1,8.8.4.4 |
|`HEALTHCHECK_INTERVAL`| No | Seconds between health checks |`HEALTHCHECK_INTERVAL=30`| 10 seconds |
|`HEALTHCHECK_DNS_HOST`| No | DNS health check host |`HEALTHCHECK_DNS_HOST=abc.com`| google.com |
|`HEALTHCHECK_PING_IP`| No | Ping health check IP |`HEALTHCHECK_PING_IP=1.2.3.4`| 8.8.8.8 |

`LAN_NETWORK` is required to ensure packets from squid can return to their source.

## Ports
| Port | Proto | Required | Function | Example |
|----------|----------|----------|----------|----------|
| `8080` | TCP | Yes | Squid Proxy | `8080:8080`|

# How to setup PIA VPN
The container will fail to boot if any of the config options are not set or if `VPN_REGION` does not map to a valid .ovpn file present in the /etc/openvpn/configs directory. If no `VPN_REGION` is set, the container will display all available regions. Simply set `VPN_REGION` to the PIA region you prefer (e.g. `VPN_REGION=ca_toronto`) with no .ovpn extension. Auto injects credentials from `VPN_USERNAME` and `VPN_PASSWORD` into a temporary .ovpn file.

# Issues
If you are having issues with this container please submit an issue on GitHub.  
Please provide logs, Docker version and other information that can simplify reproducing the issue.  
If possible, always use the most up to date version of Docker, you operating system, kernel and the container itself. Support is always a best-effort basis.

### Credits:
[DyonR/docker-qbittorrentvpn](https://github.com/DyonR/docker-qbittorrentvpn)
[MarkusMcNugen/docker-qBittorrentvpn](https://github.com/MarkusMcNugen/docker-qBittorrentvpn)  
[DyonR/jackettvpn](https://github.com/DyonR/jackettvpn)  
