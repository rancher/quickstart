#!/bin/bash -x
rancher_server_ip=${1:-172.22.101.101}
admin_password=${2:-password}
curlimage="appropriate/curl"
jqimage="stedolan/jq"

agent_ip=`ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1`
echo $agent_ip `hostname` >> /etc/hosts

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
        -s "https://$rancher_server_ip/v3-public/localProviders/local?action=login" -H 'content-type: application/json' --data-binary '{"username":"admin","password":"'$admin_password'"}' --insecure)
    LOGINTOKEN=$(echo $LOGINRESPONSE | docker run --rm -i $jqimage -r .token)

    if [ "$LOGINTOKEN" != "null" ]; then
        break
    else
        sleep 5
    fi
done

# Test if cluster is created
while true; do
  CLUSTERID=$(docker run \
    --rm \
    $curlimage \
      -sLk \
      -H "Authorization: Bearer $LOGINTOKEN" \
      "https://$rancher_server_ip/v3/clusters?name=quickstart" | docker run --rm -i $jqimage -r '.data[].id')

  if [ -n "$CLUSTERID" ]; then
    break
  else
    sleep 5
  fi
done

if [ `hostname` == "node-01" ]; then
  ROLEFLAGS="--etcd --controlplane --worker"
else
  #ROLEFLAGS="--worker"
  ROLEFLAGS="--worker"
fi

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

# Show the command
COMPLETECMD="$AGENTCMD $ROLEFLAGS --internal-address $agent_ip --address $agent_ip "
$COMPLETECMD
