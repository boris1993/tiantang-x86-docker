#!/usr/bin/env bash

set -eu

PROCESS_PATH="/usr/local/bin/ttnode_168"
PROCESS_NAME="ttnode_168"
DATA_DIR="/data"
LOG_FILE="/var/log/app.log"
TIME="$(date '+%F +%T')"

if ! pgrep ${PROCESS_NAME}; then
  echo "[$TIME] $PROCESS_NAME seems not running. Starting..." >> ${LOG_FILE}
  nohup ${PROCESS_PATH} -p ${DATA_DIR} >> ${LOG_FILE} 2>&1 &
fi
