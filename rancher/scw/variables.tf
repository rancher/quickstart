# Variables for Scaleway infrastructure module

variable "scw_project_id" {
  type        = string
  description = "Scaleway project id used to create infrastructure"
}

variable "scw_access_key" {
  type        = string
  description = "Scaleway access key used to create infrastructure"
}

variable "scw_secret_key" {
  type        = string
  description = "Scaleway secret key used to create infrastructure"
}

variable "scw_zone" {
  type        = string
  description = "Scaleway zone used for all resources"
  default     = "fr-par-1"
}

variable "scw_region" {
  type        = string
  description = "Scaleway region used for all resources"
  default     = "fr-par"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all instances"
  default     = "DEV1-M"
}

variable "rancher_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server cluster"
  default     = "v1.22.10+k3s1"
}

variable "workload_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.22.10-rke2r2"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.7.1"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format: v0.0.0)"
  default     = "2.6.6"
}

# Required
variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap, min. 12 characters"
}

# Local variables used to reduce repetition
locals {
  node_username = "root"
}
