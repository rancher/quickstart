# Scaleway Rancher Quickstart

Two single-node RKE Kubernetes clusters will be created from two instances running Ubuntu 20.04 (Focal Fossa) and Docker.
Both instances will be accessible over SSH using the SSH keys `id_rsa` and `id_rsa.pub`.

## Variables

###### `scw_project_id`

- **Required**
Scaleway project id used to create infrastructure

###### `scw_access_key`

- **Required**
Scaleway access key used to create infrastructure

###### `scw_secret_key`

- **Required**
Scaleway secret key used to create infrastructure

###### `scw_zone`

- Default: **`"fr-par-1"`**
Scaleway zone used for all resources

###### `scw_region`

- Default: **`"fr-par"`**
Scaleway region used for all resources

###### `prefix`

- Default: **`"quickstart"`**
Prefix added to names of all resources

###### `instance_type`

- Default: **`"DEV1-M"`**
Droplet size used for all droplets

###### `docker_version`

- Default: **`"19.03"`**
Docker version to install on nodes

###### `rke_kubernetes_version`

- Default: **`"v1.20.4-rancher1-1"`**
Kubernetes version to use for Rancher server RKE cluster

See `rancher-common` module variable `rke_kubernetes_version` for more details.

###### `workload_kubernetes_version`

- Default: **`"v1.19.8-rancher1-1"`**
Kubernetes version to use for managed workload cluster

See `rancher-common` module variable `workload_kubernetes_version` for more details.

###### `cert_manager_version`

- Default: **`"1.0.4"`**
Version of cert-manager to install alongside Rancher (format: 0.0.0)

See `rancher-common` module variable `cert_manager_version` for more details.

###### `rancher_version`

- Default: **`"v2.5.7"`**
Rancher server version (format v0.0.0)

See `rancher-common` module variable `rancher_version` for more details.

###### `rancher_server_admin_password`

- **Required**
Admin password to use for Rancher server bootstrap

See `rancher-common` module variable `admin_password` for more details.
