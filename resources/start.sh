#!/usr/bin/env bash

set -eu

LOG_FILE="/var/log/app.log"

echo "Starting the cron" >> "$LOG_FILE"
/etc/init.d/cron start

liveness-check.sh &

init.sh &

tail -f /var/log/app.log
