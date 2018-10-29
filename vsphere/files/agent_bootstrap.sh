#!/bin/sh
set -x

curlimage=appropriate/curl
jqimage=stedolan/jq
cluster_name=qs-cluster

if [ $# -lt 2 ]; then
  echo "required argument missing"
  exit 1
fi

rancher_server_ip=$1
rancher_password=$2

for image in $curlimage $jqimage; do
  until docker inspect $image > /dev/null 2>&1; do
    docker pull $image
    sleep 2
  done
done

while true; do
  docker run --rm $curlimage -sLk https://$rancher_server_ip/ping && break
  sleep 5
done

# Login
while true; do

    LOGINRESPONSE=$(docker run \
        --rm \
        $curlimage \
        -s "https://$rancher_server_ip/v3-public/localProviders/local?action=login" -H 'content-type: application/json' --data-binary '{"username":"admin","password":"'$rancher_password'"}' --insecure)
    LOGINTOKEN=$(echo $LOGINRESPONSE | docker run --rm -i $jqimage -r .token)

    if [ "$LOGINTOKEN" != "null" ]; then
        break
    else
        sleep 5
    fi
done

# Get the Agent Image from the rancher server
while true; do
  AGENTIMAGE=$(docker run \
    --rm \
    $curlimage \
      -sLk \
      -H "Authorization: Bearer $LOGINTOKEN" \
      "https://$rancher_server_ip/v3/settings/agent-image" | docker run --rm -i $jqimage -r '.value')

  if [ -n "$AGENTIMAGE" ]; then
    break
  else
    sleep 5
  fi
done

until docker inspect $AGENTIMAGE > /dev/null 2>&1; do
  docker pull $AGENTIMAGE
  sleep 2
done

# Test if cluster is created
while true; do
  CLUSTERID=$(docker run \
    --rm \
    $curlimage \
      -sLk \
      -H "Authorization: Bearer $LOGINTOKEN" \
      "https://$rancher_server_ip/v3/clusters?name=$cluster_name" | docker run --rm -i $jqimage -r '.data[].id')

  if [ -n "$CLUSTERID" ]; then
    break
  else
    sleep 5
  fi
done

ROLEFLAG="all-roles"

# Get token
# Test if cluster is created
while true; do
  AGENTCMD=$(docker run \
    --rm \
    $curlimage \
      -sLk \
      -H "Authorization: Bearer $LOGINTOKEN" \
      "https://$rancher_server_ip/v3/clusterregistrationtoken?clusterId=$CLUSTERID" | docker run --rm -i $jqimage -r '.data[].nodeCommand' | head -1)

  if [ -n "$AGENTCMD" ]; then
    break
  else
    sleep 5
  fi
done

# Combine command and flags
COMPLETECMD="$AGENTCMD --$ROLEFLAG"

# Run command
$COMPLETECMD
