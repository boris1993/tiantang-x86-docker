#!/usr/bin/env bash

set -eu

PROCESS_NAME="ttnode_168"
LOG_FILE="/var/log/app.log"
UPNP_LOG_FILE="/var/log/upnp.log"

echo "Starting the cron" >> "$LOG_FILE"
/etc/init.d/cron start

# Then wait for the program running
echo "Waiting for the program be running" >> "$LOG_FILE"
while ! pgrep ${PROCESS_NAME}; do
  sleep 30
done

# Sleep for 2 minutes in order to wait for the program 
# finishes self-updating
echo "Sleeping for 30 seconds in order to let the app fully initialized" >> "$LOG_FILE"
sleep 30

# Then initialize the UPnP
echo "Initializing UPnP port forwarding in the background" >> "$LOG_FILE"
set-port-forwarding.sh > "$UPNP_LOG_FILE" 2>&1 &

tail -f /var/log/app.log

