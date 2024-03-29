#!/bin/bash

PROCESS_PATH="/usr/local/bin/ttnode"
PROCESS_NAME="ttnode"
DATA_DIR="/data"
LOG_FILE="/var/log/app.log"
UPNP_LOG_FILE="/var/log/upnp.log"
COMMAND="${PROCESS_PATH} -p ${DATA_DIR}"

export PROCESS_PATH
export PROCESS_NAME
export DATA_DIR
export LOG_FILE
export UPNP_LOG_FILE
export COMMAND
export PATH

print_time() {
    date '+%F +%T'
}

export -f print_time
