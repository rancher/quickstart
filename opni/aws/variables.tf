# Required
variable "aws_access_key" {
  type        = string
  description = "AWS access key used to create infrastructure"
}

# Required
variable "aws_secret_key" {
  type        = string
  description = "AWS secret key used to create AWS infrastructure"
}

variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap, min. 12 characters"
  default     = "adminadminadmin"
}

variable "aws_session_token" {
  type        = string
  description = "AWS session token used to create AWS infrastructure"
  default     = ""
}

variable "aws_region" {
  type        = string
  description = "AWS region used for all resources"
  default     = "us-east-1"
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "opni-quickstart"
}

variable "aws_zone" {
  type        = string
  description = "AWS zone used for all resources"
  default     = "us-east-1b"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3a.2xlarge"
}

variable "opni_cluster_node_count" {
  type = number
  description = "Amount of nodes in the Opni cluster"
  default = 3
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use"
  default     = "v1.23.14+rke2r1"
}

variable "opni_version" {
  type        = string
  description = "Opni version"
  default     = "0.9.1"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside Rancher and Opni (format: 0.0.0)"
  default     = "1.10.0"
}

variable "rancher_version" {
  type        = string
  description = "Rancher version"
  default     = "2.7.1"
}

variable "longhorn_version" {
  type = string
  description = "Longhorn version"
  default = "1.4.1"
}

variable "rancher_helm_repository" {
  type        = string
  description = "The helm repository, where the Rancher helm chart is installed from"
  default     = "https://releases.rancher.com/server-charts/latest"
}

variable "rke2_token" {
  type = string
  description = "RKE2 token for joining the cluster"
}

# Local variables used to reduce repetition
locals {
  node_username = "ec2-user"
}
