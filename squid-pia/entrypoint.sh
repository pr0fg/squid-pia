#!/bin/bash

echo '[INFO] Starting squid proxy...' | ts '%Y-%m-%d %H:%M:%.S'

rm -rf /run/squid.pid
tail -vn 0 -F /var/log/squid/access.log 2>&1 >/dev/null &
squid -N -d 1
