#!/bin/bash
set -e
INTERNETIP="$(dig +short myip.opendns.com @resolver1.opendns.com -4)"
echo $(jq -n --arg internetip "$INTERNETIP" '{"internet_ip":$internetip}')
