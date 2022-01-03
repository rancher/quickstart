# Hetzner Cloud Rancher Quickstart

Two single-node RKE Kubernetes clusters will be created from two instances running Ubuntu 20.04 and Docker.
Both instances will be accessible over SSH using the auto-generated SSH keys `id_rsa` and `id_rsa.pub`.

## Variables

###### `hcloud_token`
- **Required**
Hetzner Cloud API token used to create infrastructure

###### `hcloud_location`
- Default: **`"fsn1"`**
Hetzner Location used for all resources

###### `network_zone`
- Default: **`"eu-central"`**
Zone to create the network in

###### `network_cidr`
- Default: **`"10.0.0.0/16"`**
Network to create for private communication

###### `network_cidr`
- Default: **`"10.0.1.0/24"`**
Subnet to create for private communication. Must be part of the CIDR defined in `network_cidr`.

###### `prefix`
- Default: **`"quickstart"`**
Prefix added to names of all resources

###### `instance_type`
- Default: **`"cx21"`**
Type of instance to be used for all instances

###### `docker_version`
- Default: **`"19.03"`**
Docker version to install on nodes

###### `rancher_kubernetes_version`
- Default: **`"v1.21.8+k3s1"`**
Kubernetes version to use for Rancher server cluster

See `rancher-common` module variable `rancher_kubernetes_version` for more details.

###### `workload_kubernetes_version`
- Default: **`"v1.20.12-rancher1-1"`**
Kubernetes version to use for managed workload cluster

See `rancher-common` module variable `workload_kubernetes_version` for more details.

###### `cert_manager_version`
- Default: **`"1.5.3"`**
Version of cert-manager to install alongside Rancher (format: 0.0.0)

See `rancher-common` module variable `cert_manager_version` for more details.

###### `rancher_version`
- Default: **`"v2.6.3"`**
Rancher server version (format v0.0.0)

See `rancher-common` module variable `rancher_version` for more details.

###### `rancher_server_admin_password`
- **Required**
Admin password to use for Rancher server bootstrap

See `rancher-common` module variable `admin_password` for more details.

