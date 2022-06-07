# GCP Rancher Quickstart

Two single-node RKE Kubernetes clusters will be created from two Compute Engine instances running SLES 15 and Docker.
Both instances will have wide-open security groups and will be accessible over SSH using the SSH keys
`id_rsa` and `id_rsa.pub`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | 4.15.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.2.2 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.15.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_common"></a> [rancher\_common](#module\_rancher\_common) | ../rancher-common | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_address.quickstart_node_address](https://registry.terraform.io/providers/hashicorp/google/4.15.0/docs/resources/compute_address) | resource |
| [google_compute_address.rancher_server_address](https://registry.terraform.io/providers/hashicorp/google/4.15.0/docs/resources/compute_address) | resource |
| [google_compute_firewall.rancher_fw_allowall](https://registry.terraform.io/providers/hashicorp/google/4.15.0/docs/resources/compute_firewall) | resource |
| [google_compute_instance.quickstart_node](https://registry.terraform.io/providers/hashicorp/google/4.15.0/docs/resources/compute_instance) | resource |
| [google_compute_instance.rancher_server](https://registry.terraform.io/providers/hashicorp/google/4.15.0/docs/resources/compute_instance) | resource |
| [local_file.ssh_public_key_openssh](https://registry.terraform.io/providers/hashicorp/local/2.2.2/docs/resources/file) | resource |
| [local_sensitive_file.ssh_private_key_pem](https://registry.terraform.io/providers/hashicorp/local/2.2.2/docs/resources/sensitive_file) | resource |
| [tls_private_key.global_key](https://registry.terraform.io/providers/hashicorp/tls/3.1.0/docs/resources/private_key) | resource |
| [google_compute_image.sles](https://registry.terraform.io/providers/hashicorp/google/4.15.0/docs/data-sources/compute_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_gcp_account_json"></a> [gcp\_account\_json](#input\_gcp\_account\_json) | File path and name of service account access token file. | `string` | n/a | yes |
| <a name="input_gcp_project"></a> [gcp\_project](#input\_gcp\_project) | GCP project in which the quickstart will be deployed. | `string` | n/a | yes |
| <a name="input_rancher_server_admin_password"></a> [rancher\_server\_admin\_password](#input\_rancher\_server\_admin\_password) | Admin password to use for Rancher server bootstrap | `string` | n/a | yes |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install alongside Rancher (format: 0.0.0) | `string` | `"1.7.1"` | no |
| <a name="input_docker_version"></a> [docker\_version](#input\_docker\_version) | Docker version to install on nodes | `string` | `"19.03"` | no |
| <a name="input_gcp_region"></a> [gcp\_region](#input\_gcp\_region) | GCP region used for all resources. | `string` | `"us-east4"` | no |
| <a name="input_gcp_zone"></a> [gcp\_zone](#input\_gcp\_zone) | GCP zone used for all resources. | `string` | `"us-east4-a"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Machine type used for all compute instances | `string` | `"n1-standard-2"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"quickstart"` | no |
| <a name="input_rancher_kubernetes_version"></a> [rancher\_kubernetes\_version](#input\_rancher\_kubernetes\_version) | Kubernetes version to use for Rancher server cluster | `string` | `"v1.21.11+k3s1"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher server version (format: v0.0.0) | `string` | `"2.6.4"` | no |
| <a name="input_workload_kubernetes_version"></a> [workload\_kubernetes\_version](#input\_workload\_kubernetes\_version) | Kubernetes version to use for managed workload cluster | `string` | `"v1.21.10-rancher1-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_node_ip"></a> [rancher\_node\_ip](#output\_rancher\_node\_ip) | n/a |
| <a name="output_rancher_server_url"></a> [rancher\_server\_url](#output\_rancher\_server\_url) | n/a |
| <a name="output_workload_node_ip"></a> [workload\_node\_ip](#output\_workload\_node\_ip) | n/a |
<!-- END_TF_DOCS -->
