# Variables for Azure infrastructure module

variable "azure_subscription_id" {
  type        = string
  description = "Azure subscription id under which resources will be provisioned"
  sensitive   = true
}

variable "azure_client_id" {
  type        = string
  description = "Azure client id used to create resources"
  sensitive   = true
}

variable "azure_client_secret" {
  type        = string
  description = "Client secret used to authenticate with Azure apis"
  sensitive   = true
}

variable "azure_tenant_id" {
  type        = string
  description = "Azure tenant id used to create resources"
  sensitive   = true
}

variable "azure_location" {
  type        = string
  description = "Azure location used for all resources"
  default     = "East US"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all linux virtual machines"
  default     = "Standard_DS2_v2"
}

variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "19.03"
}

variable "rke_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server RKE cluster"
  default     = "v1.20.4-rancher1-1"
}

variable "workload_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.19.9-rancher1-1"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.0.4"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format: v0.0.0)"
  default     = "v2.5.7"
}

# Required
variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap"
}

# Required
variable "windows_admin_password" {
  type        = string
  description = "Admin password to use for the Windows VM"
}

# Local variables used to reduce repetition
locals {
  node_username = "ubuntu"
}
