#!/usr/bin/env bash

PROCESS_NAME="ttnode"
LOG_FILE="/var/log/app.log"
UPNP_LOG_FILE="/var/log/upnp.log"

# Sleep for 30 seconds in order to let the app finishes the self-update
sleep 30

# Wait for the program running
echo "Waiting for the program be running" >> "$LOG_FILE"
while ! pgrep ${PROCESS_NAME}; do
  sleep 30
done

# Sleep for another 30 seconds in order to wait for the program finishes initializing
echo "Sleeping for 60 seconds in order to let the app fully initialized" >> "$LOG_FILE"
sleep 60

# Then initialize the UPnP
echo "Initializing UPnP port forwarding in the background" >> "$LOG_FILE"
set-port-forwarding.sh > "$UPNP_LOG_FILE" 2>&1 &
