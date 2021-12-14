#!/bin/bash

set -e

# Sleep for 30 seconds in order to let the app finishes the self-update
sleep 30

# Wait for the program running
echo "[$(print_time)] Waiting for the program be running" >> "$LOG_FILE"
while ! pgrep "${PROCESS_NAME}"; do
  echo "[$(print_time)] The process ${PROCESS_NAME} cannot be found. Sleeping for 30 second then checking again" >> "$LOG_FILE"
  sleep 30
done

print-qrcode.sh >> "${LOG_FILE}"
