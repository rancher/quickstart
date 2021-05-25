variable "vsphere_server" {
}

variable "vsphere_server_allow_unverified_ssl" {
  description = "Allow use of unverified SSL certificates (Ex: Self signed)"
  default = false
}
variable "vsphere_user" {
}

variable "vsphere_password" {
}

variable "vsphere_datacenter" {
}

variable "vsphere_datastore" {
}

variable "vsphere_resource_pool" {
}

variable "vsphere_network" {
}

variable "vsphere_virtual_machine" {
  description = "Virtual Machine template name"
}

variable "prefix" {
  description = "Prefix to use for various resources"
}

variable "authorized_keys" {
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

variable "domain_for_rancher" {
  default = "nip.io"
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

# This variable is used only if ingress_tls_source is set to either "rancher" or "letsEncrypt
variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "0.15.1"
}

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
  default = "quickstart"
}

variable "vm_username" {
  default = "root"
}

variable "vm_cpus" {
  default = 2
}

variable "vm_memory" {
  default = 4096
}

variable "vm_disk" {
  default = 80
}
