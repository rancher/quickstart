# AWS NeuVector Quickstart

This will create a single node RKE2 cluster running on an EC2 instance with SLES 15 and install NeuVector into the cluster.
The instance will have wide-open security groups and will be accessible over SSH using the SSH keys
`id_rsa` and `id_rsa.pub`.

Optionally, you can also deploy the Rancher Management Server into the same cluster to test the Rancher and NeuVector integration.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.17.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.5.1 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.11.0 |
| <a name="requirement_local"></a> [local](#requirement\_local) | 2.2.3 |
| <a name="requirement_rancher2"></a> [rancher2](#requirement\_rancher2) | 1.24.0 |
| <a name="requirement_ssh"></a> [ssh](#requirement\_ssh) | 1.2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | 3.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.17.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.5.1 |
| <a name="provider_local"></a> [local](#provider\_local) | 2.2.3 |
| <a name="provider_rancher2.bootstrap"></a> [rancher2.bootstrap](#provider\_rancher2.bootstrap) | 1.24.0 |
| <a name="provider_ssh"></a> [ssh](#provider\_ssh) | 1.2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.neuvector_server](https://registry.terraform.io/providers/hashicorp/aws/4.17.0/docs/resources/instance) | resource |
| [aws_key_pair.quickstart_key_pair](https://registry.terraform.io/providers/hashicorp/aws/4.17.0/docs/resources/key_pair) | resource |
| [aws_security_group.neuvector_sg_allowall](https://registry.terraform.io/providers/hashicorp/aws/4.17.0/docs/resources/security_group) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [helm_release.cluster_issuer](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [helm_release.neuvector](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [helm_release.rancher_server](https://registry.terraform.io/providers/hashicorp/helm/2.5.1/docs/resources/release) | resource |
| [local_file.kube_config_server_yaml](https://registry.terraform.io/providers/hashicorp/local/2.2.3/docs/resources/file) | resource |
| [local_file.ssh_public_key_openssh](https://registry.terraform.io/providers/hashicorp/local/2.2.3/docs/resources/file) | resource |
| [local_sensitive_file.ssh_private_key_pem](https://registry.terraform.io/providers/hashicorp/local/2.2.3/docs/resources/sensitive_file) | resource |
| [rancher2_bootstrap.admin](https://registry.terraform.io/providers/rancher/rancher2/1.24.0/docs/resources/bootstrap) | resource |
| [ssh_resource.install_rke2](https://registry.terraform.io/providers/loafoe/ssh/1.2.0/docs/resources/resource) | resource |
| [ssh_resource.retrieve_config](https://registry.terraform.io/providers/loafoe/ssh/1.2.0/docs/resources/resource) | resource |
| [ssh_resource.rke2_config](https://registry.terraform.io/providers/loafoe/ssh/1.2.0/docs/resources/resource) | resource |
| [ssh_resource.rke2_config_dir](https://registry.terraform.io/providers/loafoe/ssh/1.2.0/docs/resources/resource) | resource |
| [tls_private_key.global_key](https://registry.terraform.io/providers/hashicorp/tls/3.4.0/docs/resources/private_key) | resource |
| [aws_ami.sles](https://registry.terraform.io/providers/hashicorp/aws/4.17.0/docs/data-sources/ami) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_access_key"></a> [aws\_access\_key](#input\_aws\_access\_key) | AWS access key used to create infrastructure | `string` | n/a | yes |
| <a name="input_aws_secret_key"></a> [aws\_secret\_key](#input\_aws\_secret\_key) | AWS secret key used to create AWS infrastructure | `string` | n/a | yes |
| <a name="input_neuvector_admin_password"></a> [neuvector\_admin\_password](#input\_neuvector\_admin\_password) | Admin password for NeuVector | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | AWS region used for all resources | `string` | `"us-east-1"` | no |
| <a name="input_aws_session_token"></a> [aws\_session\_token](#input\_aws\_session\_token) | AWS session token used to create AWS infrastructure | `string` | `""` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version of cert-manager to install alongside NeuVector (format: 0.0.0) | `string` | `"1.7.1"` | no |
| <a name="input_install_rancher"></a> [install\_rancher](#input\_install\_rancher) | Also install Rancher and setup SSO for NeuVector | `bool` | `false` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Instance type used for all EC2 instances | `string` | `"t3a.xlarge"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version to use | `string` | `"v1.22.10-rc2+rke2r1"` | no |
| <a name="input_neuvector_chart_version"></a> [neuvector\_chart\_version](#input\_neuvector\_chart\_version) | NeuVector helm chart version | `string` | `"2.2.0"` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix added to names of all resources | `string` | `"neuvector-quickstart"` | no |
| <a name="input_rancher_server_admin_password"></a> [rancher\_server\_admin\_password](#input\_rancher\_server\_admin\_password) | Admin password to use for Rancher server bootstrap, min. 12 characters | `string` | `"adminadminadmin"` | no |
| <a name="input_rancher_version"></a> [rancher\_version](#input\_rancher\_version) | Rancher version | `string` | `"2.6.5"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_neuvector_url"></a> [neuvector\_url](#output\_neuvector\_url) | n/a |
| <a name="output_node_ip"></a> [node\_ip](#output\_node\_ip) | n/a |
| <a name="output_rancher_url"></a> [rancher\_url](#output\_rancher\_url) | n/a |
<!-- END_TF_DOCS -->