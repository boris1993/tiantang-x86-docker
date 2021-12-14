#!/bin/bash

set -e

if [ "$SKIP_UPNP_AUTOCONFIG" = true ]; then
  exit 0
fi

if [ -z "$ETH_ADAPTER_NAME" ]; then 
  echo "[$(print_time)] ERROR: Environment variable ETH_ADAPTER_NAME is not set. Unable to determine the Ethernet interface. Skipping setting up UPnP."
  exit 1
fi

EXPECTED_NUMBER_OF_LISTENING_PORTS=7

RULE_NAME_REGEX="tiantang:(TCP|UDP):"

OLD_IFS="$IFS"
IFS=$(printf '\n')

# Retrieve the IP address of the active ethernet interface
ETH_IP_ADDRESS=$(ip a sh dev "$ETH_ADAPTER_NAME" | grep -v inet6 | grep inet | awk '{split($2,a,"/"); print a[1]}')

LISTENING_PORTS=$(netstat -nlp | grep ttnode)
NUMBER_OF_LISTENING_PORTS=$(echo "$LISTENING_PORTS" | wc -l)

while [ "$NUMBER_OF_LISTENING_PORTS" != "$EXPECTED_NUMBER_OF_LISTENING_PORTS" ]; do
  echo "[$(print_time)] Found $NUMBER_OF_LISTENING_PORTS, less than the expecting of $EXPECTED_NUMBER_OF_LISTENING_PORTS . Will re-check after 10 seconds."
  sleep 10

  LISTENING_PORTS=$(netstat -4nlp | grep ttnode)
  NUMBER_OF_LISTENING_PORTS=$(echo "$LISTENING_PORTS" | wc -l)
done

EXISTING_RULES=$(upnpc -l | grep -E "$RULE_NAME_REGEX" | awk '{print $2, $3}')

echo -e "[$(print_time)] IP address of the ethernet interface is $ETH_IP_ADDRESS\n"
echo -e "[$(print_time)] Outputs of netstat are:\n${LISTENING_PORTS}\n"
echo -e "[$(print_time)] Existing UPnP rules of tiantang are:\n${EXISTING_RULES}\n"

# Find out ports listening and add the UPnP rule
echo "$LISTENING_PORTS" | while read -r line; do
  ADDR_AND_PORT=$(echo "$line" | awk '{print $4}')
  PROTOCOL=$(echo "$line" | awk '{print toupper($1)}')

  LISTENING_ADDR=$(echo "$ADDR_AND_PORT" | awk '{split($1,a,":"); print a[1]}')
  LISTENING_PORT=$(echo "$ADDR_AND_PORT" | awk '{split($1,a,":"); print a[2]}')

  if [ "$LISTENING_ADDR" = "127.0.0.1" ]; then
    continue
  fi

  RULE_TO_BE_CHECKED="${PROTOCOL} ${LISTENING_PORT}->${ETH_IP_ADDRESS}:${LISTENING_PORT}"
  echo -e "[$(print_time)] Checking if \"${RULE_TO_BE_CHECKED}\" exists in the UPnP rules...\n"

  # Continue to the next one if the current port is forwarded
  if echo "$EXISTING_RULES" | grep -q "$RULE_TO_BE_CHECKED"; then
    echo -e "[$(print_time)] Found \"${RULE_TO_BE_CHECKED}\". Continueing to the next one.\n"
    continue
  fi

  echo -e "========Adding new rule========\n"
  upnpc -e "tiantang:$PROTOCOL:$LISTENING_PORT" -a "$ETH_IP_ADDRESS" "$LISTENING_PORT" "$LISTENING_PORT" "$PROTOCOL"
  echo -e "==========Rule added===========\n"
  echo -e "\n"
done

echo "${EXISTING_RULES}" | while read -r line; do
  PROTOCOL=$(echo "${line}" | awk '{print tolower($1)}')
  PORT=$(echo "${line}" | awk '{split($2,a,"->"); print a[1]}')
  NETSTAT_TARGET_OUTPUT="0.0.0.0:${PORT}"
  
  MATCHED_LINE_COUNT=$(echo "${LISTENING_PORTS}" | grep "${PROTOCOL}" | grep -c "${NETSTAT_TARGET_OUTPUT}")

  if [ "${MATCHED_LINE_COUNT}" = 0 ]; then
    echo -e "[$TIME] Found invalid rule ${PORT}/${PROTOCOL}\n"
    echo -e "========Deleting rule========\n"
    upnpc -d "${PORT}" "${PROTOCOL}"
    echo -e "========Rule deleted=========\n"
  fi
done

IFS="$OLD_IFS"
