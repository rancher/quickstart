# Azure Rancher Quickstart

Two single-node Kubernetes clusters will be created from two linux virtual instances running SLES 15 and Docker.
Both instances will have wide-open security groups and will be accessible over SSH using the SSH keys
`id_rsa` and `id_rsa.pub`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.59.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.4.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.59.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_common"></a> [rancher\_common](#module\_rancher\_common) | ../rancher-common | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_linux_virtual_machine.quickstart-node](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_linux_virtual_machine.rancher_server](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/linux_virtual_machine) | resource |
| [azurerm_network_interface.quickstart-node-interface](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/network_interface) | resource |
| [azurerm_network_interface.quickstart-windows-node-interface](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/network_interface) | resource |
| [azurerm_network_interface.rancher-server-interface](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/network_interface) | resource |
| [azurerm_public_ip.quickstart-node-pip](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/public_ip) | resource |
| [azurerm_public_ip.quickstart-windows-node-pip](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/public_ip) | resource |
| [azurerm_public_ip.rancher-server-pip](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rancher-quickstart](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/resource_group) | resource |
| [azurerm_subnet.rancher-quickstart-internal](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/subnet) | resource |
| [azurerm_virtual_machine_extension.join-rancher](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_network.rancher-quickstart](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/virtual_network) | resource |
| [azurerm_windows_virtual_machine.quickstart-windows-node](https://registry.terraform.io/providers/hashicorp/azurerm/3.59.0/docs/resources/windows_virtual_machine) | resource |
| [local_file.ssh_public_key_openssh](https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/file) | resource |
| [local_sensitive_file.ssh_private_key_pem](https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/sensitive_file) | resource |
| [tls_private_key.global_key](https://registry.terraform.io/providers/hashicorp/tls/4.0.4/docs/resources/private_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure client id used to create resources | `string` | n/a | yes |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Client secret used to authenticate with Azure apis | `string` | n/a | yes |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription id under which resources will be provisioned | `string` | n/a | yes |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure tenant id used to create resources | `string` | n/a | yes |
| <a name="input_rancher_server_admin_password"></a> [rancher\_server\_admin\_password](#input\_rancher\_server\_admin\_password) | Admin password to use for Rancher server bootstrap, min. 12 characters | `string` | n/a | yes |
| <a name="input_windows_admin_password"></a> [windows\_admin\_password](#input\_windows\_admin\_password) | Admin password to use for the Windows VM | `string` | n/a | yes |
| <a name="input_add_windows_node"></a> [add\_windows\_node](#input\_add\_windows\_node) | Add a windows node to the workload cluster | `bool` | `false` | no |
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Azure location used for all resources | `string` | `"East US"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install alongside Rancher (format: 0.0.0) | `string` | `"1.11.0"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for all linux virtual machines | `string` | `"Standard_DS2_v2"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"quickstart"` | no |
| <a name="input_rancher_helm_repository"></a> [rancher\_helm\_repository](#input\_rancher\_helm\_repository) | The helm repository, where the Rancher helm chart is installed from | `string` | `"https://releases.rancher.com/server-charts/latest"` | no |
| <a name="input_rancher_kubernetes_version"></a> [rancher\_kubernetes\_version](#input\_rancher\_kubernetes\_version) | Kubernetes version to use for Rancher server cluster | `string` | `"v1.24.14+k3s1"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher server version (format: v0.0.0) | `string` | `"2.7.9"` | no |
| <a name="input_workload_kubernetes_version"></a> [workload\_kubernetes\_version](#input\_workload\_kubernetes\_version) | Kubernetes version to use for managed workload cluster | `string` | `"v1.24.14+rke2r1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_node_ip"></a> [rancher\_node\_ip](#output\_rancher\_node\_ip) | n/a |
| <a name="output_rancher_server_url"></a> [rancher\_server\_url](#output\_rancher\_server\_url) | n/a |
| <a name="output_windows-workload-ips"></a> [windows-workload-ips](#output\_windows-workload-ips) | n/a |
| <a name="output_workload_node_ip"></a> [workload\_node\_ip](#output\_workload\_node\_ip) | n/a |
<!-- END_TF_DOCS -->
