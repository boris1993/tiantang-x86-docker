#!/bin/bash

set -e

if ! pgrep "${PROCESS_NAME}"; then
  echo "[$(print_time)] $PROCESS_NAME seems not running. Starting..." >> "${LOG_FILE}"
  # shellcheck disable=SC2086 # Word splitting is expected here
  nohup ${COMMAND} >> ${LOG_FILE} 2>&1 &
fi
