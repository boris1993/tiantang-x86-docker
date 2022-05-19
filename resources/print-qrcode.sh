#!/bin/bash

set -e

# shellcheck disable=SC1091
. /usr/local/bin/set-variables.sh

TIANTANG_UID=$(${COMMAND} | grep "uid" | awk '{printf("%s", $5)}')

if [ -n "$TIANTANG_UID" ]; then
  echo "===================================================="
  echo "[$(print_time)] Your UID is: ${TIANTANG_UID}"
  echo ""
  qrencode -t UTF8 -m 2 -o - "$TIANTANG_UID"
  echo ""
  echo "===================================================="
fi 
