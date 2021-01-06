variable "linode_token" {
  description = "Your Linode APIv4 Access Token"
}

variable "linode_domain_for_rancher" {
  description = "Domain created in Linode, under which rancher DNS entry is created"
}

variable "prefix" {
  description = "Prefix to use for various resources"
}

variable "authorized_keys" {
}

variable "node_username" {
  default = "root"
}

variable "root_password" {
}

variable "region" {
}

variable "instance_type" {
  default = "g6-standard-4"
}

variable "instance_image" {
  default = "linode/ubuntu18.04"
}

variable "ssh_private_key_path" {
  default = "~/.ssh/id_rsa"
}

variable "rke_node_count" {
  default = "3"
}

variable "docker_version" {
  default = "19.03.2"
}

variable "rke_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server RKE cluster"
  default     = "v1.18.8-rancher1-1"
}

variable "rancher_server_name" {
  default = "rancher"
}
variable "rancher_version" {
  default = "stable"
}

variable "rancher_replicas" {
  default = "3"
}

variable ingress_tls_source {
  type        = string
  description = "Specify the source of TLS certificates. Valid options: rancher, letsEncrypt, secret"
  default     = "rancher"
}

# This option is relevant only if ingress_tls_source is set to "letsEncrypt"
variable lets_encrypt_email {
  type        = string
  description = "Email address used for communication about your certificate (for example, expiry notices)"
  default     = null
}

# This option is relevant only if ingress_tls_source is set to "secret"
variable server_certificate {
  type        = string
  description = "Specify the location of the server certificate file (public). Ex: /home/ubuntu/tls.crt"
  default     = null
}

# This option is relevant only if ingress_tls_source is set to "secret"
variable server_certificate_key {
  type        = string
  description = "Specify the location of the server certificate private key file. Ex: /home/ubuntu/tls.key"
  default     = null
}

# This option is relevant only if ingress_tls_source is set to "secret" and if private CA is used
variable use_private_ca {
  type        = bool
  description = "Specify if private CA signed certificates are used"
  default     = false
}

variable server_private_ca_certificate {
  type        = string
  description = "Specify the location of the private CA certificate file. Ex: /home/ubuntu/ca.crt"
  default     = null
}
# Required
variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap"
}

variable "create_workload_cluster" {
  type        = bool
  description = "Specify if workload cluster needs to be created after completion of Rancher Server installation"
  default     = true
}

variable "workload_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.17.11-rancher1-1"
}

variable "workload_cluster_name" {
  default = "quickstart-linode-custom"
}