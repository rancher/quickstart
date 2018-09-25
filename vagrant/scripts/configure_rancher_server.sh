#!/bin/bash -x

rancher_server_ip="172.22.101.101"
default_password=${1:-password}
rancher_server_version=${2:-stable}
kubernetes_version=${3:-v1.10.1-rancher1}
registry_prefix="rancher"
curl_prefix="appropriate"

protocol="http"

ros config set rancher.docker.storage_driver overlay
ros engine switch docker-1.12.6
system-docker restart docker
sleep 5

rancher_command="rancher/rancher:$rancher_server_version" 

echo Installing Rancher Server
sudo docker run -d --restart=always \
 -p 443:443 \
 -p 80:80 \
 $rancher_env_vars \
 --restart=unless-stopped \
 --name rancher-server \
$rancher_command

# wait until rancher server is ready
while true; do
  wget -T 5 -c https://localhost/ping && break
  sleep 5
done

# Login
LOGINRESPONSE=$(docker run --net=host \
    --rm \
    $curl_prefix/curl \
    -s "https://127.0.0.1/v3-public/localProviders/local?action=login" -H 'content-type: application/json' --data-binary '{"username":"admin","password":"admin"}' --insecure)

LOGINTOKEN=$(echo $LOGINRESPONSE | jq -r .token)

# Change password
docker run --net=host \
    --rm \
    $curl_prefix/curl \
     -s "https://127.0.0.1/v3/users?action=changepassword" -H 'content-type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"currentPassword":"admin","newPassword":"'$default_password'"}' --insecure

# Create API key
APIRESPONSE=$(docker run --net host \
    --rm \
    $curl_prefix/curl \
     -s "https://127.0.0.1/v3/token" -H 'content-type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"type":"token","description":"automation","name":""}' --insecure)

# Extract and store token
APITOKEN=$(echo $APIRESPONSE | jq -r .token)

# Configure server-url
SERVERURLRESPONSE=$(docker run --net host \
    --rm \
    $curl_prefix/curl \
     -s 'https://127.0.0.1/v3/settings/server-url' -H 'content-type: application/json' -H "Authorization: Bearer $APITOKEN" -X PUT --data-binary '{"name":"server-url","value":"https://'$rancher_server_ip'"}' --insecure)

# Create cluster
CLUSTERRESPONSE=$(docker run --net host \
    --rm \
    $curl_prefix/curl \
     -s 'https://127.0.0.1/v3/cluster' -H 'content-type: application/json' -H "Authorization: Bearer $APITOKEN" \
     --data-binary "{\"type\":\"cluster\",\"rancherKubernetesEngineConfig\":{\"ignoreDockerVersion\":false,\"sshAgentAuth\":false,\"type\":\"rancherKubernetesEngineConfig\",\"kubernetesVersion\":\"$kubernetes_version\",\"authentication\":{\"type\":\"authnConfig\",\"strategy\":\"x509\"},\"network\":{\"type\":\"networkConfig\",\"plugin\":\"flannel\",\"flannelNetworkProvider\":{\"iface\":\"eth1\"},\"calicoNetworkProvider\":null},\"ingress\":{\"type\":\"ingressConfig\",\"provider\":\"nginx\"},\"services\":{\"type\":\"rkeConfigServices\",\"kubeApi\":{\"podSecurityPolicy\":false,\"type\":\"kubeAPIService\"},\"etcd\":{\"type\":\"etcdService\",\"extraArgs\":{\"heartbeat-interval\":500,\"election-timeout\":5000}}}},\"name\":\"quickstart\"}" --insecure)

# Extract clusterid to use for generating the docker run command
CLUSTERID=`echo $CLUSTERRESPONSE | jq -r .id`

# Generate cluster registration token
CLUSTERREGTOKEN=$(docker run --net=host \
    --rm \
    $curl_prefix/curl \
     -s 'https://127.0.0.1/v3/clusterregistrationtoken' -H 'content-type: application/json' -H "Authorization: Bearer $APITOKEN" --data-binary '{"type":"clusterRegistrationToken","clusterId":"'$CLUSTERID'"}' --insecure)
