#!/bin/sh

set -e

# Sleep for 30 seconds in order to let the app finishes the self-update
sleep 30

# Wait for the program running
echo "[$TIME] Waiting for the program be running" >> "$LOG_FILE"
while ! pgrep "${PROCESS_NAME}"; do
  echo "[$TIME] The process ${PROCESS_NAME} cannot be found. Sleeping for 30 second then checking again" >> "$LOG_FILE"
  sleep 30
done

print-qrcode.sh >> "${LOG_FILE}"

SLEEP_SECONDS=90
# Sleep for a while in order to wait for the program finishes initializing
echo "[$TIME] Sleeping for ${SLEEP_SECONDS} seconds in order to let the app fully initialized" >> "$LOG_FILE"
sleep ${SLEEP_SECONDS}

# Then initialize the UPnP
echo "[$TIME] Initializing UPnP port forwarding in the background" >> "$LOG_FILE"
set-port-forwarding.sh > "$UPNP_LOG_FILE" 2>&1 &
