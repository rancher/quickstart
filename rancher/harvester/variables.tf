# Variables for DO infrastructure module

variable "kubeconfig_path" {
  type        = string
  description = "Kubeconfig file path to connect to the Harvester cluster"
}

variable "kubecontext" {
  type        = string
  description = "Name of the kubernetes context to use to the Harvester cluster"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

variable "namespace" {
  type        = string
  description = "Harvester namespace to deploy the VMs into"
  default     = "default"
}

variable "network_name" {
  type        = string
  description = "Name of the Harvester network to deploy the VMs into"
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

variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap, min. 12 characters"
}

# Local variables used to reduce repetition
locals {
  node_username = "ubuntu"
  cluster_node_command = templatefile(
    "${path.module}/files/userdata_quickstart_node.template",
    {
      register_command = module.rancher_common.custom_cluster_command
    }
  )
}
