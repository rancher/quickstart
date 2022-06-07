# Variables for Linode infrastructure module

variable "linode_token" {
  type        = string
  description = "Linode API token used to create infrastructure"
}

variable "linode_region" {
  type        = string
  description = "Linode region used for all resources"
  default     = "eu-central"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

variable "linode_type" {
  type        = string
  description = "Linode type used for all droplets"
  default     = "g6-standard-2"
}

variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "19.03"
}

variable "rancher_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server cluster"
  default     = "v1.21.11+k3s1"
}

variable "workload_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.21.10-rancher1-1"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.7.1"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format: v0.0.0)"
  default     = "2.6.4"
}

# Required
variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap"
}

# Local variables used to reduce repetition
locals {
  node_username = "root"
}
