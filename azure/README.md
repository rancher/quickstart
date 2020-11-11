# Azure Rancher Quickstart

Two single-node RKE Kubernetes clusters will be created from two linux virtual instances running Ubuntu 18.04 and Docker.
Both instances will have wide-open security groups and will be accessible over SSH using the SSH keys
`id_rsa` and `id_rsa.pub`.

## Variables

###### `azure_subscription_id`
- **Required**
Azure subscription id to which the resources are billed

###### `azure_client_id`
- **Required**
Azure client id associated with the provisioned resources

##### `azure_client_secret`
- **Required**
Azure client secret used to authenticate the azure client id

##### `azure_tenant_id`
- **Required**
Azure tenant id (active directory instance) under which the resources will exist

###### `azure_location`
- Default: **`"East US"`**
Azure location used for all resources

###### `prefix`
- Default: **`"quickstart"`**
Prefix added to names of all resources

###### `instance_type`
- Default: **`"Standard_DS2_v2"`**
Instance type used for all linux virtual instances

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

