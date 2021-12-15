#!/bin/bash

while [ ! -f /tmp/.yfnode.log ]
do
  sleep 0.5
done

tail -f /tmp/.yfnode.log | while read -r line; do echo "[yfnode] $line"; done >> "$LOG_FILE" &
