#!/bin/bash

OLD_IFS="$IFS"
IFS=$'\n'

# Retrieve the IP address of the active ethernet interface
ETH_IP_ADDRESS=$(ip a sh up scope global | grep inet | awk '{split($2,a,"/"); print a[1]}')
echo "IP address of the ethernet interface is $ETH_IP_ADDRESS"

LISTENING_PORTS=$(netstat -nlp | grep qemu)
echo -e "Outputs of netstat are:\n$LISTENING_PORTS"

#UPNPC_OUTPUT_TCP=$(upnpc -l | grep "$ETH_IP_ADDRESS" | grep "TCP")
#UPNPC_OUTPUT_UDP=$(upnpc -l | grep "$ETH_IP_ADDRESS" | grep "UDP")

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
done

IFS="$OLD_IFS"

