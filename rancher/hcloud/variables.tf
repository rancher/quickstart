# Variables for Hetzner Cloud infrastructure module

variable "hcloud_token" {
  type        = string
  description = "Hetzner Cloud API token used to create infrastructure"
}

variable "hcloud_location" {
  type        = string
  description = "Hetzner location used for all resources"
  default     = "fsn1"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

variable "network_cidr" {
  type        = string
  description = "Network to create for private communication"
  default     = "10.0.0.0/8"
}

variable "network_ip_range" {
  type        = string
  description = "Subnet to create for private communication. Must be part of the CIDR defined in `network_cidr`."
  default     = "10.0.1.0/24"
}

variable "network_zone" {
  type        = string
  description = "Zone to create the network in"
  default     = "eu-central"
}

variable "instance_type" {
  type        = string
  description = "Type of instance to be used for all instances"
  default     = "cx21"
}

variable "rancher_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server cluster"
  default     = "v1.24.14+k3s1"
}

variable "workload_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.24.14+rke2r1"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher (format: 0.0.0)"
  default     = "1.11.0"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format: v0.0.0)"
  default     = "2.7.9"
}

variable "rancher_helm_repository" {
  type        = string
  description = "The helm repository, where the Rancher helm chart is installed from"
  default     = "https://releases.rancher.com/server-charts/latest"
}

variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap, min. 12 characters"
}

# Local variables used to reduce repetition
locals {
  node_username = "root"
}
