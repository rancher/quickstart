# OpenStack Rancher Quickstart

Two single-node RKE Kubernetes clusters will be created from two linux virtual instances running Ubuntu 18.04 and Docker.
Both instances will have wide-open security groups and will be accessible over SSH using the SSH keys
`id_rsa` and `id_rsa.pub`.

## Variables

###### `openstack_floating_ip_pool`
- **Required**
The name of the pool from which to obtain the floating IPs

###### `openstack_auth_url`
- **Optional**; required if `openstack_cloud` is not specified.
The OpenStack Identity authentication URL.
If omitted, the `OS_AUTH_URL` environment variable is used.

###### `openstack_cloud`
- **Optional**; required if `openstack_auth_url` is not specified.
An entry in a `clouds.yaml` file.
See the OpenStack openstacksdk documentation for more information about clouds.yaml files.
If omitted, the `OS_CLOUD` environment variable is used.

###### `openstack_region`
- **Optional**
The region of the OpenStack cloud to use.
If omitted, the `OS_REGION_NAME` environment variable is used.

###### `openstack_user_name`
- **Optional**
The Username to login with.
f omitted, the `OS_USERNAME` environment variable is used.

###### `openstack_project_name`
- **Optional**
The Name of the Project.
If omitted, the `OS_TENANT_ID` or `OS_PROJECT_ID` environment variables are used.

###### `openstack_password`
- **Optional**
The Password to login with.
If omitted, the `OS_PASSWORD` environment variable is used.

###### `openstack_domain_name`
- **Optional**
The Name of the Domain to scope to.
If omitted, the `OS_DOMAIN_NAME` environment variable is used.

###### `openstack_user_id`
- **Optional**
The User ID to login with.
If omitted, the `OS_USER_ID` environment variable is checked.

###### `openstack_application_credential_id`
- **Optional**
The ID of an application credential to authenticate with.
An `openstack_application_credential_secret` has to bet set along with this parameter.

###### `openstack_application_credential_name`
- **Optional**
The name of an application credential to authenticate with.
Requires `openstack_user_id`, or `openstack_user_name` and `openstack_user_domain_name` (or `openstack_user_domain_id`) to be set.

###### `openstack_application_credential_secret`
- **Optional**
The secret of an application credential to authenticate with.
Required by `openstack_application_credential_id` or `openstack_application_credential_name`.

###### `openstack_project_id`
- **Optional**
The ID of the Project to login with.
If omitted, the `OS_TENANT_ID` or `OS_PROJECT_ID` environment variables are used.

###### `openstack_token`
- **Optional**
The auth token to login with.
A token is an expiring, temporary means of access issued via the Keystone service.
If omitted, the `OS_TOKEN` or `OS_AUTH_TOKEN` environment variables are used.

###### `openstack_user_domain_name`
- **Optional**
The domain name where the user is located.
If omitted, the `OS_USER_DOMAIN_NAME` environment variable is checked.

###### `openstack_user_domain_id`
- **Optional**
The domain ID where the user is located.
If omitted, the `OS_USER_DOMAIN_ID` environment variable is checked.

###### `openstack_project_domain_name`
- **Optional**
The domain name where the project is located.
If omitted, the `OS_PROJECT_DOMAIN_NAME` environment variable is checked.

###### `openstack_project_domain_id`
- **Optional**
The domain ID where the project is located.
If omitted, the `OS_PROJECT_DOMAIN_ID` environment variable is checked.

###### `openstack_domain_id`
- **Optional**
The Name of the Domain to scope to.
If omitted, the `OS_DOMAIN_ID` environment variable is checked.

###### `openstack_insecure`
- **Optional**
Trust self-signed SSL certificates.
If omitted, the `OS_INSECURE` environment variable is used.

###### `openstack_cacert_file`
- **Optional**
Specify a custom CA certificate when communicating over SSL.
You can specify either a path to the file or the contents of the certificate.
If omitted, the `OS_CACERT` environment variable is used.

###### `openstack_cert`
- **Optional**
Specify client certificate file for SSL client authentication.
You can specify either a path to the file or the contents of the certificate.
If omitted the `OS_CERT` environment variable is used.

###### `openstack_key`
- **Optional**
Specify client private key file for SSL client authentication.
You can specify either a path to the file or the contents of the key.
If omitted the `OS_KEY` environment variable is used.

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
