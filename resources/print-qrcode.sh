#!/bin/sh

set -e

# shellcheck disable=SC1091
. /usr/local/bin/set-variables.sh

TIANTANG_UID=$(${COMMAND} | grep "uid" | awk '{printf("%s", $3)}')

if [ -n "$TIANTANG_UID" ]; then
  printf "====================================================\n"
  printf "[%s] Your UID is: ${TIANTANG_UID}\n" "$TIME"
  printf "\n"
  qrencode -t UTF8 -m 2 -o - "${TIANTANG_UID}"
  printf "\n"
  printf "====================================================\n"
fi 
