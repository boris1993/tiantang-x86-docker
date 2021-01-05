#!/usr/bin/env bash

set -eu

if [ "$SKIP_UPNP_AUTOCONFIG" = true ]; then
  exit 0
fi

RULE_NAME_REGEX="tiantang:(TCP|UDP):"

OLD_IFS="$IFS"
IFS=$'\n'

# Retrieve the IP address of the active ethernet interface
ETH_IP_ADDRESS=$(ip a sh up scope global | grep inet | awk '{split($2,a,"/"); print a[1]}')
echo "IP address of the ethernet interface is $ETH_IP_ADDRESS"

LISTENING_PORTS=$(netstat -nlp | grep qemu)
echo -e "Outputs of netstat are:\n$LISTENING_PORTS"

# Delete existing configurations
EXISTING_RULES=$(upnpc -l | grep -E "$RULE_NAME_REGEX" | awk '{print $2, $3}')

for line in $EXISTING_RULES
do
  RULE_PROTOCOL=$(echo "$line" | awk '{print $1}')
  FORWARDED_PORT=$(echo "$line" | awk '{split($2,a,"->"); split(a[2],b,":"); print b[2]}')
  echo "===Deleting rule $ETH_IP_ADDRESS:$FORWARDED_PORT/$RULE_PROTOCOL==="
  upnpc -d "$FORWARDED_PORT" "$RULE_PROTOCOL"
  echo "===Rule deleted==="
done

# Find out ports listening and add the UPnP rule
for line in $LISTENING_PORTS
do
  ADDR_AND_PORT=$(echo "$line" | awk '{print $4}')
  PROTOCOL=$(echo "$line" | awk '{print toupper($1)}')

  LISTENING_ADDR=$(echo "$ADDR_AND_PORT" | awk '{split($1,a,":"); print a[1]}')
  LISTENING_PORT=$(echo "$ADDR_AND_PORT" | awk '{split($1,a,":"); print a[2]}')

  if [ "$LISTENING_ADDR" == "127.0.0.1" ]; then
    continue
  fi

  echo "========Adding new rule========"
  upnpc -e "tiantang:$PROTOCOL:$LISTENING_PORT" -a "$ETH_IP_ADDRESS" "$LISTENING_PORT" "$LISTENING_PORT" "$PROTOCOL"
  echo "==========Rule added==========="
  echo -e "\n"
done

IFS="$OLD_IFS"

