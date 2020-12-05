# Linode Rancher Quickstart

Two single-node RKE Kubernetes clusters will be created from two linodes running Ubuntu 18.04 and Docker.
Both instances will be accessible over SSH using the SSH keys `id_rsa` and `id_rsa.pub`.

## Variables

###### `linode_token`
- **Required**
Linode API token used to create infrastructure

###### `linode_region`
- Default: **`"eu-central"`**
Linode region used for all resources

###### `prefix`
- Default: **`"quickstart"`**
Prefix added to names of all resources

###### `linode_size`
- Default: **`"g6-standard-2"`**
Linode size used for all linode

###### `docker_version`
- Default: **`"19.03"`**
Docker version to install on nodes

###### `rke_kubernetes_version`
- Default: **`"v1.19.3-rancher1-2"`**
Kubernetes version to use for Rancher server RKE cluster

See `rancher-common` module variable `rke_kubernetes_version` for more details.

###### `workload_kubernetes_version`
- Default: **`"v1.17.11-rancher1-1"`**
Kubernetes version to use for managed workload cluster

See `rancher-common` module variable `workload_kubernetes_version` for more details.

###### `cert_manager_version`
- Default: **`"0.15.1"`**
Version of cert-manager to install alongside Rancher (format: 0.0.0)

See `rancher-common` module variable `cert_manager_version` for more details.

###### `rancher_version`
- Default: **`"v2.4.8"`**
Rancher server version (format v0.0.0)

See `rancher-common` module variable `rancher_version` for more details.

###### `rancher_server_admin_password`
- **Required**
Admin password to use for Rancher server bootstrap

See `rancher-common` module variable `admin_password` for more details.

