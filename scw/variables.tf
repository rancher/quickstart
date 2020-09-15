# Variables for SCW infrastructure module

variable "scw_access_key" {
  type        = string
  description = "SCW access key"
}

variable "scw_secret_key" {
  type        = string
  description = "SCW secret key"
}

variable "scw_organization_id" {
  type        = string
  description = "SCW organization id"
}

variable "scw_zone" {
  type        = string
  description = "SCW zone used for all resources."
  default     = "fr-par-1"
}

variable "scw_region" {
  type        = string
  description = "SCW region used for all resources."
  default     = "fr-par"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

variable "machine_type" {
  type        = string
  description = "Machine type used for all compute instances"
  default     = "DEV1-M"
}

variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "19.03"
}

variable "rke_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server RKE cluster"
  default     = "v1.18.3-rancher2-2"
}

variable "workload_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.17.6-rancher2-2"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-mananger to install alongside Rancher (format: 0.0.0)"
  default     = "0.12.0"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format: v0.0.0)"
  default     = "v2.4.6"
}

# Required
variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap"
}

# Local variables used to reduce repetition
locals {
  node_username = "centos"
}
