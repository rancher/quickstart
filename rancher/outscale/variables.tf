# Variables for Outscale infrastructure module
# Required
variable "access_key_id" {
  type        = string
  description = "Outscale access key"
}

# Required
variable "secret_key_id" {
  type        = string
  description = "Outscale secret key"
}


variable "region" {
  type        = string
  description = "Outscale region"
  default     = "eu-west-2"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all VM"
  default     = "tinav3.c4r8p2"
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
  description = "Rancher server version (format: 0.0.0)"
  default     = "2.6.6"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

variable "omi" {
  type        = string
  description = "Outscale machine Image to use for all instances"
  default     = "ami-504e6b16"
}


# Required
variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap, min. 12 characters"
}

# Local variables used to reduce repetition
locals {
  node_username = "outscale"
}
