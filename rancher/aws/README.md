# AWS Rancher Quickstart

Two single-node Kubernetes clusters will be created from two EC2 instances running SLES 15 and Docker.
Both instances will have wide-open security groups and will be accessible over SSH using the SSH keys
`id_rsa` and `id_rsa.pub`.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.1.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.4.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 4.0.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.1.0 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.4.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 4.0.4 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_rancher_common"></a> [rancher\_common](#module\_rancher\_common) | ../rancher-common | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_instance.quickstart_node](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/resources/instance) | resource |
| [aws_instance.quickstart_node_win](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/resources/instance) | resource |
| [aws_instance.rancher_server](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/resources/instance) | resource |
| [aws_internet_gateway.rancher_gateway](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/resources/internet_gateway) | resource |
| [aws_key_pair.quickstart_key_pair](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/resources/key_pair) | resource |
| [aws_route_table.rancher_route_table](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/resources/route_table) | resource |
| [aws_route_table_association.rancher_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/resources/route_table_association) | resource |
| [aws_security_group.rancher_sg_allowall](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/resources/security_group) | resource |
| [aws_subnet.rancher_subnet](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/resources/subnet) | resource |
| [aws_vpc.rancher_vpc](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/resources/vpc) | resource |
| [local_file.ssh_public_key_openssh](https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/file) | resource |
| [local_sensitive_file.ssh_private_key_pem](https://registry.terraform.io/providers/hashicorp/local/2.4.0/docs/resources/sensitive_file) | resource |
| [tls_private_key.global_key](https://registry.terraform.io/providers/hashicorp/tls/4.0.4/docs/resources/private_key) | resource |
| [aws_ami.sles](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/data-sources/ami) | data source |
| [aws_ami.windows](https://registry.terraform.io/providers/hashicorp/aws/5.1.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key used to create infrastructure | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key used to create AWS infrastructure | `string` | n/a | yes |
| <a name="input_rancher_server_admin_password"></a> [rancher\_server\_admin\_password](#input\_rancher\_server\_admin\_password) | Admin password to use for Rancher server bootstrap, min. 12 characters | `string` | n/a | yes |
| <a name="input_add_windows_node"></a> [add\_windows\_node](#input\_add\_windows\_node) | Add a windows node to the workload cluster | `bool` | `false` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | `"us-east-1"` | no |
| <a name="input_aws_session_token"></a> [aws\_session\_token](#input\_aws\_session\_token) | AWS session token used to create AWS infrastructure | `string` | `""` | no |
| <a name="input_aws_zone"></a> [aws\_zone](#input\_aws\_zone) | AWS zone used for all resources | `string` | `"us-east-1b"` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install alongside Rancher (format: 0.0.0) | `string` | `"1.11.0"` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for all EC2 instances | `string` | `"t3a.medium"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"quickstart"` | no |
| <a name="input_rancher_helm_repository"></a> [rancher\_helm\_repository](#input\_rancher\_helm\_repository) | The helm repository, where the Rancher helm chart is installed from | `string` | `"https://releases.rancher.com/server-charts/latest"` | no |
| <a name="input_rancher_kubernetes_version"></a> [rancher\_kubernetes\_version](#input\_rancher\_kubernetes\_version) | Kubernetes version to use for Rancher server cluster | `string` | `"v1.24.14+k3s1"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher server version (format: v0.0.0) | `string` | `"2.7.9"` | no |
| <a name="input_windows_instance_type"></a> [windows\_instance\_type](#input\_windows\_instance\_type) | Instance type used for all EC2 windows instances | `string` | `"t3a.large"` | no |
| <a name="input_workload_kubernetes_version"></a> [workload\_kubernetes\_version](#input\_workload\_kubernetes\_version) | Kubernetes version to use for managed workload cluster | `string` | `"v1.24.14+rke2r1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_rancher_node_ip"></a> [rancher\_node\_ip](#output\_rancher\_node\_ip) | n/a |
| <a name="output_rancher_server_url"></a> [rancher\_server\_url](#output\_rancher\_server\_url) | n/a |
| <a name="output_windows-workload-ips"></a> [windows-workload-ips](#output\_windows-workload-ips) | n/a |
| <a name="output_windows_password"></a> [windows\_password](#output\_windows\_password) | Returns the decrypted AWS generated windows password |
| <a name="output_workload_node_ip"></a> [workload\_node\_ip](#output\_workload\_node\_ip) | n/a |
<!-- END_TF_DOCS -->
