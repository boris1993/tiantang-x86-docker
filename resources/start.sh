#!/bin/sh

set -e

# shellcheck disable=SC1091
. /usr/local/bin/set-variables.sh

printf "[%s] Starting the cron\n" "$TIME" >> "$LOG_FILE"
/etc/init.d/cron start

liveness-check.sh &

init.sh &

tail -f /var/log/app.log
