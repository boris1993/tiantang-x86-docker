#!/bin/sh

set -e

if ! pgrep "${PROCESS_NAME}"; then
  echo "[$TIME] $PROCESS_NAME seems not running. Starting..." >> "${LOG_FILE}"
  # shellcheck disable=SC2086 # Word splitting is expected here
  nohup ${COMMAND} >> ${LOG_FILE} 2>&1 &
fi
