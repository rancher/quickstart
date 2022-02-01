# Rancher Common Terraform Module

The `rancher-common` module contains all resources that do not depend on a
specific cloud provider. RKE, Kubernetes, Helm, and Rancher providers are used
given the necessary information about the infrastructure created in a cloud
provider.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.4.1 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.1.0 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | 1.22.2 |
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | 1.0.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.4.1 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.1.0 |
| <a name="provider_rancher2.admin"></a> [rancher2.admin](#provider\_rancher2.admin) | 1.22.2 |
| <a name="provider_rancher2.bootstrap"></a> [rancher2.bootstrap](#provider\_rancher2.bootstrap) | 1.22.2 |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | 1.0.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [helm_release.rancher_server](https://registry.terraform.io/providers/hashicorp/helm/2.4.1/docs/resources/release) | resource |
| [local_file.kube_config_server_yaml](https://registry.terraform.io/providers/hashicorp/local/2.1.0/docs/resources/file) | resource |
| [local_file.kube_config_workload_yaml](https://registry.terraform.io/providers/hashicorp/local/2.1.0/docs/resources/file) | resource |
| [rancher2_bootstrap.admin](https://registry.terraform.io/providers/rancher/rancher2/1.22.2/docs/resources/bootstrap) | resource |
| [rancher2_cluster.quickstart_workload](https://registry.terraform.io/providers/rancher/rancher2/1.22.2/docs/resources/cluster) | resource |
| [ssh_resource.install_k3s](https://registry.terraform.io/providers/loafoe/ssh/1.0.1/docs/resources/resource) | resource |
| [ssh_resource.retrieve_config](https://registry.terraform.io/providers/loafoe/ssh/1.0.1/docs/resources/resource) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_admin_password"></a> [admin\_password](#input\_admin\_password) | Admin password to use for Rancher server bootstrap | `string` | n/a | yes |
| <a name="input_node_public_ip"></a> [node\_public\_ip](#input\_node\_public\_ip) | Public IP of compute node for Rancher cluster | `string` | n/a | yes |
| <a name="input_node_username"></a> [node\_username](#input\_node\_username) | Username used for SSH access to the Rancher server cluster node | `string` | n/a | yes |
| <a name="input_rancher_server_dns"></a> [rancher\_server\_dns](#input\_rancher\_server\_dns) | DNS host name of the Rancher server | `string` | n/a | yes |
| <a name="input_ssh_private_key_pem"></a> [ssh\_private\_key\_pem](#input\_ssh\_private\_key\_pem) | Private key used for SSH access to the Rancher server cluster node | `string` | n/a | yes |
| <a name="input_workload_cluster_name"></a> [workload\_cluster\_name](#input\_workload\_cluster\_name) | Name for created custom workload cluster | `string` | n/a | yes |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install alongside Rancher (format: 0.0.0) | `string` | `"1.5.3"` | no |
| <a name="input_node_internal_ip"></a> [node\_internal\_ip](#input\_node\_internal\_ip) | Internal IP of compute node for Rancher cluster | `string` | `""` | no |
| <a name="input_rancher_kubernetes_version"></a> [rancher\_kubernetes\_version](#input\_rancher\_kubernetes\_version) | Kubernetes version to use for Rancher server cluster | `string` | `"v1.21.8+k3s1"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher server version (format v0.0.0) | `string` | `"v2.6.3"` | no |
| <a name="input_windows_prefered_cluster"></a> [windows\_prefered\_cluster](#input\_windows\_prefered\_cluster) | Activate windows supports for the custom workload cluster | `bool` | `false` | no |
| <a name="input_workload_kubernetes_version"></a> [workload\_kubernetes\_version](#input\_workload\_kubernetes\_version) | Kubernetes version to use for managed workload cluster | `string` | `"v1.20.6-rancher1-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_custom_cluster_command"></a> [custom\_cluster\_command](#output\_custom\_cluster\_command) | Docker command used to add a node to the quickstart cluster |
| <a name="output_custom_cluster_windows_command"></a> [custom\_cluster\_windows\_command](#output\_custom\_cluster\_windows\_command) | Docker command used to add a windows node to the quickstart cluster |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | n/a |
<!-- END_TF_DOCS -->
