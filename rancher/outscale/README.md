<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.4.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_outscale"></a> [outscale](#provider\_outscale) | 0.7.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_common"></a> [rancher\_common](#module\_rancher\_common) | ../rancher-common | n/a |

## Resources

| Name | Type |
|------|------|
| [local_file.ssh_public_key_openssh](https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/file) | resource |
| [local_sensitive_file.ssh_private_key_pem](https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/sensitive_file) | resource |
| [outscale_keypair.quickstart_key_pair](https://registry.terraform.io/providers/outscale-dev/outscale/latest/docs/resources/keypair) | resource |
| [outscale_public_ip.quickstart_node](https://registry.terraform.io/providers/outscale-dev/outscale/latest/docs/resources/public_ip) | resource |
| [outscale_public_ip.rancher_server](https://registry.terraform.io/providers/outscale-dev/outscale/latest/docs/resources/public_ip) | resource |
| [outscale_public_ip_link.quickstart_node](https://registry.terraform.io/providers/outscale-dev/outscale/latest/docs/resources/public_ip_link) | resource |
| [outscale_public_ip_link.rancher_server](https://registry.terraform.io/providers/outscale-dev/outscale/latest/docs/resources/public_ip_link) | resource |
| [outscale_security_group.rancher_sg_allowall](https://registry.terraform.io/providers/outscale-dev/outscale/latest/docs/resources/security_group) | resource |
| [outscale_security_group_rule.security_group_rule01](https://registry.terraform.io/providers/outscale-dev/outscale/latest/docs/resources/security_group_rule) | resource |
| [outscale_vm.quickstart_node](https://registry.terraform.io/providers/outscale-dev/outscale/latest/docs/resources/vm) | resource |
| [outscale_vm.rancher_server](https://registry.terraform.io/providers/outscale-dev/outscale/latest/docs/resources/vm) | resource |
| [tls_private_key.global_key](https://registry.terraform.io/providers/hashicorp/tls/4.0.4/docs/resources/private_key) | resource |
| [outscale_public_ip.rancher_server](https://registry.terraform.io/providers/outscale-dev/outscale/latest/docs/data-sources/public_ip) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_key_id"></a> [access\_key\_id](#input\_access\_key\_id) | Outscale access key | `string` | n/a | yes |
| <a name="input_rancher_server_admin_password"></a> [rancher\_server\_admin\_password](#input\_rancher\_server\_admin\_password) | Admin password to use for Rancher server bootstrap, min. 12 characters | `string` | n/a | yes |
| <a name="input_secret_key_id"></a> [secret\_key\_id](#input\_secret\_key\_id) | Outscale secret key | `string` | n/a | yes |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install alongside Rancher (format: 0.0.0) | `string` | `"1.11.0"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for all VM | `string` | `"tinav3.c4r8p2"` | no |
| <a name="input_omi"></a> [omi](#input\_omi) | Outscale machine Image to use for all instances | `string` | `"ami-504e6b16"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"quickstart"` | no |
| <a name="input_rancher_helm_repository"></a> [rancher\_helm\_repository](#input\_rancher\_helm\_repository) | The helm repository, where the Rancher helm chart is installed from | `string` | `"https://releases.rancher.com/server-charts/latest"` | no |
| <a name="input_rancher_kubernetes_version"></a> [rancher\_kubernetes\_version](#input\_rancher\_kubernetes\_version) | Kubernetes version to use for Rancher server cluster | `string` | `"v1.24.14+k3s1"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher server version (format: 0.0.0) | `string` | `"2.7.9"` | no |
| <a name="input_region"></a> [region](#input\_region) | Outscale region | `string` | `"eu-west-2"` | no |
| <a name="input_workload_kubernetes_version"></a> [workload\_kubernetes\_version](#input\_workload\_kubernetes\_version) | Kubernetes version to use for managed workload cluster | `string` | `"v1.24.14+rke2r1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_node_ip"></a> [rancher\_node\_ip](#output\_rancher\_node\_ip) | n/a |
| <a name="output_rancher_server_url"></a> [rancher\_server\_url](#output\_rancher\_server\_url) | n/a |
| <a name="output_workload_node_ip"></a> [workload\_node\_ip](#output\_workload\_node\_ip) | n/a |
<!-- END_TF_DOCS -->
