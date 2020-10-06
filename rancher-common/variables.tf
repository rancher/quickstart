# Variables for rancher common module

# Required
variable "node_public_ip" {
  type        = string
  description = "Public IP of compute node for Rancher cluster"
}

variable "node_internal_ip" {
  type        = string
  description = "Internal IP of compute node for Rancher cluster"
  default     = ""
}

# Required
# This variable is useful to specify multiple nodes for the rancher cluster
# If this is not null, the previous variables node_public_ip and
# node_internal_ip are not used.
#
# Example:
# default = [
#   {
#     public_ip = "1.1.1.1",
#     private_ip = "1.1.1.1",
#     roles = ["etcd", "controlplane", "worker"]
#   },
#   {
#     public_ip = "2.2.2.2",
#     private_ip = "2.2.2.2",
#     roles = ["etcd", "controlplane", "worker"]
#   },
#   {
#     public_ip = "3.3.3.3",
#     private_ip = "3.3.3.3",
#     roles = ["etcd", "controlplane", "worker"]
#   }
# ]
#
variable "rancher_nodes" {
  type = list(object({
    public_ip = string
    private_ip = string
    roles = list(string)
  }))
  default = null
  description = "List of compute nodes for Rancher cluster"
}

# Required
variable "node_username" {
  type        = string
  description = "Username used for SSH access to the Rancher server cluster node"
}

# Required
variable "ssh_private_key_pem" {
  type        = string
  description = "Private key used for SSH access to the Rancher server cluster node(s)"
}

variable "rke_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server RKE cluster"
  default     = "v1.20.4-rancher1-1"
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

# This variable is used only if ingress_tls_source is set to either "rancher" or "letsEncrypt
variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.0.4"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format v0.0.0)"
  default     = "v2.5.7"
}

variable "system_default_registry" {
  type        = string
  description = "Specify the default registry for various RKE images. Ex: artifactory.company.com/docker"
  default     = null
}

variable "rancher_image_registry" {
  type        = string
  description = "Specify the registry of rancher image. Ex: artifactory.company.com/docker"
  default     = null
}

variable "rancher_image_registry_username" {
  type        = string
  description = "Specify rancher image registry's username"
  default     = null
}

variable "rancher_image_registry_password" {
  type        = string
  description = "Specify rancher image registry's password"
  default     = null
}

variable "private_registry_url" {
  type        = string
  description = "Specify the private registry where kubernetes images are hosted. Ex: artifactory.company.com/docker"
  default     = null
}

variable "private_registry_username" {
  type        = string
  description = "Specify private registry's username"
  default     = null
}

variable "private_registry_password" {
  type        = string
  description = "Specify private registry's password"
  default     = null
}

variable "system_default_registry" {
  type        = string
  description = "Specify the default registry for various RKE images. Ex: artifactory.company.com/docker"
  default     = null
}

variable "rancher_image_registry" {
  type        = string
  description = "Specify the registry of rancher image. Ex: artifactory.company.com/docker"
  default     = null
}

variable "rancher_image_registry_username" {
  type        = string
  description = "Specify rancher image registry's username"
  default     = null
}

variable "rancher_image_registry_password" {
  type        = string
  description = "Specify rancher image registry's password"
  default     = null
}

variable "private_registry_url" {
  type        = string
  description = "Specify the private registry where kubernetes images are hosted. Ex: artifactory.company.com/docker"
  default     = null
}

variable "private_registry_username" {
  type        = string
  description = "Specify private registry's username"
  default     = null
}

variable "private_registry_password" {
  type        = string
  description = "Specify private registry's password"
  default     = null
}

# Required
variable "rancher_server_dns" {
  type        = string
  description = "DNS host name of the Rancher server. Ex: rancher.mycompany.com"
}

variable "rancher_helm_repository" {
  type        = string
  description = "Specify the URL where Rancher Helm Repository is hosted"
  default     = "https://releases.rancher.com/server-charts/latest"
}

# Required
variable "admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap"
}

# A Custom Workload/Downstream cluster is created with the following
# configuration options. Nodes can later be added to this cluster
# to this cluster by using the `docker run` bootstrap command provided
# in the cluster page of Rancher UI.
variable "create_workload_cluster" {
  type        = bool
  description = "Specify if workload cluster needs to be created after completion of Rancher Server installation"
  default     = true
}

variable "workload_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.19.8-rancher1-1"
}

# Required
variable "workload_cluster_name" {
  type        = string
  description = "Name for created custom workload cluster"
}

variable "rke_network_plugin" {
  type        = string
  description = "Network plugin used for the custom workload cluster"
  default     = "canal"
}

variable "rke_network_options" {
  description = "Network options used for the custom workload cluster"
  default     = null
}

variable "windows_prefered_cluster" {
  type        = bool
  description = "Activate windows supports for the custom workload cluster"
  default     = false
}
