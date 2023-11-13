#!/bin/bash

echo "[INFO] Starting squid daemon..." | ts '%Y-%m-%d %H:%M:%.S'
tail -vn 0 -F /var/log/squid/access.log &
squid -N -d 1
