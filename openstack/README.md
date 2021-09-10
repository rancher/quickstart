# OpenStack Rancher Quickstart

Two single-node RKE Kubernetes clusters will be created from two linux virtual instances running Ubuntu 18.04 and Docker.
Both instances will have wide-open security groups and will be accessible over SSH using the SSH keys
`id_rsa` and `id_rsa.pub`.

## Variables

###### `openstack_floating_ip_pool`
- **Required**
The name of the pool from which to obtain the floating IPs

###### `openstack_auth_url`
- **Optional**
The OpenStack Identity authentication URL.
If omitted, the `OS_AUTH_URL` environment variable is used.

###### `openstack_user_name`
- **Optional**
The Username to login with.
If omitted, the `OS_USERNAME` environment variable is used.

###### `openstack_password`
- **Optional**
The Password to login with.
If omitted, the `OS_PASSWORD` environment variable is used.

###### `openstack_region`
- **Optional**
The region of the OpenStack cloud to use.
If omitted, the `OS_REGION_NAME` environment variable is used.

###### `openstack_domain_id`
- **Optional**
The Name of the Domain to scope to.
If omitted, the `OS_DOMAIN_ID` environment variable is checked.

###### `openstack_domain_name`
- **Optional**
The Name of the Domain to scope to.
If omitted, the `OS_DOMAIN_NAME` environment variable is used.

###### `openstack_project_id`
- **Optional**
The ID of the Project to login with.
If omitted, the `OS_TENANT_ID` or `OS_PROJECT_ID` environment variables are used.

###### `openstack_project_name`
- **Optional**
The Name of the Project.
If omitted, the `OS_TENANT_ID` or `OS_PROJECT_ID` environment variables are used.

###### `openstack_insecure`
- **Optional**
Trust self-signed SSL certificates.
If omitted, the `OS_INSECURE` environment variable is used.

###### `openstack_cacert_file`
- **Optional**
Specify a custom CA certificate when communicating over SSL.
You can specify either a path to the file or the contents of the certificate.
If omitted, the `OS_CACERT` environment variable is used.

###### `prefix`
- Default: **`"quickstart"`**
Prefix added to names of all resources

###### `instance_type`
- Default: **`"m1.large"`**
Instance type used for all linux virtual instances

###### `docker_version`
- Default: **`"19.03"`**
Docker version to install on nodes

###### `rke_kubernetes_version`
- Default: **`"v1.18.3-rancher2-2"`**
Kubernetes version to use for Rancher server RKE cluster

See `rancher-common` module variable `rke_kubernetes_version` for more details.

###### `workload_kubernetes_version`
- Default: **`"v1.17.6-rancher2-2"`**
Kubernetes version to use for managed workload cluster

See `rancher-common` module variable `workload_kubernetes_version` for more details.

###### `cert_manager_version`
- Default: **`"0.12.0"`**
Version of cert-mananger to install alongside Rancher (format: 0.0.0)

See `rancher-common` module variable `cert_manager_version` for more details.

###### `rancher_version`
- Default: **`"v2.4.5"`**
Rancher server version (format v0.0.0)

See `rancher-common` module variable `rancher_version` for more details.

###### `rancher_server_admin_password`
- **Required**
Admin password to use for Rancher server bootstrap

See `rancher-common` module variable `admin_password` for more details.

###### `network_cidr`
- Default: **`"10.0.0.0/16"`**
The Network CIDR for the Rancher nodes
