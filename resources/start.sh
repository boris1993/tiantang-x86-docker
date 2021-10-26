#!/bin/bash

set -e

# shellcheck disable=SC1091
. /usr/local/bin/set-variables.sh

echo -e "[$(print_time)] Starting the cron\n" >> "$LOG_FILE"
/etc/init.d/cron start

liveness-check.sh &

init.sh &

tail -f /var/log/app.log
