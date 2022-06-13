# Linode Rancher Quickstart

Two single-node RKE Kubernetes clusters will be created from two linodes running Ubuntu 18.04 and Docker.
Both instances will be accessible over SSH using the SSH keys `id_rsa` and `id_rsa.pub`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_linode"></a> [linode](#requirement\_linode) | 1.27.2 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.2.3 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_linode"></a> [linode](#provider\_linode) | 1.27.2 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.3 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_common"></a> [rancher\_common](#module\_rancher\_common) | ../rancher-common | n/a |

## Resources

| Name | Type |
|------|------|
| [linode_instance.quickstart_node](https://registry.terraform.io/providers/linode/linode/1.27.2/docs/resources/instance) | resource |
| [linode_instance.rancher_server](https://registry.terraform.io/providers/linode/linode/1.27.2/docs/resources/instance) | resource |
| [linode_sshkey.quickstart_ssh_key](https://registry.terraform.io/providers/linode/linode/1.27.2/docs/resources/sshkey) | resource |
| [linode_stackscript.quickstart_node](https://registry.terraform.io/providers/linode/linode/1.27.2/docs/resources/stackscript) | resource |
| [local_file.ssh_public_key_openssh](https://registry.terraform.io/providers/hashicorp/local/2.2.3/docs/resources/file) | resource |
| [local_sensitive_file.ssh_private_key_pem](https://registry.terraform.io/providers/hashicorp/local/2.2.3/docs/resources/sensitive_file) | resource |
| [tls_private_key.global_key](https://registry.terraform.io/providers/hashicorp/tls/3.4.0/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_linode_token"></a> [linode\_token](#input\_linode\_token) | Linode API token used to create infrastructure | `string` | n/a | yes |
| <a name="input_rancher_server_admin_password"></a> [rancher\_server\_admin\_password](#input\_rancher\_server\_admin\_password) | Admin password to use for Rancher server bootstrap, min. 12 characters | `string` | n/a | yes |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install alongside Rancher (format: 0.0.0) | `string` | `"1.7.1"` | no |
| <a name="input_docker_version"></a> [docker\_version](#input\_docker\_version) | Docker version to install on nodes | `string` | `"19.03"` | no |
| <a name="input_linode_region"></a> [linode\_region](#input\_linode\_region) | Linode region used for all resources | `string` | `"eu-central"` | no |
| <a name="input_linode_type"></a> [linode\_type](#input\_linode\_type) | Linode type used for all droplets | `string` | `"g6-standard-2"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"quickstart"` | no |
| <a name="input_rancher_kubernetes_version"></a> [rancher\_kubernetes\_version](#input\_rancher\_kubernetes\_version) | Kubernetes version to use for Rancher server cluster | `string` | `"v1.22.9+k3s1"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher server version (format: v0.0.0) | `string` | `"2.6.5"` | no |
| <a name="input_workload_kubernetes_version"></a> [workload\_kubernetes\_version](#input\_workload\_kubernetes\_version) | Kubernetes version to use for managed workload cluster | `string` | `"v1.22.9-rancher1-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_node_ip"></a> [rancher\_node\_ip](#output\_rancher\_node\_ip) | n/a |
| <a name="output_rancher_server_url"></a> [rancher\_server\_url](#output\_rancher\_server\_url) | n/a |
| <a name="output_workload_node_ip"></a> [workload\_node\_ip](#output\_workload\_node\_ip) | n/a |
<!-- END_TF_DOCS -->
