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

# Required
variable "neuvector_admin_password" {
  type        = string
  description = "Admin password for NeuVector"
  default     = "AI2zSYMFuCZ3HUeyNNMj1urUpCSEfgE0"
}

variable "install_rancher" {
  type        = bool
  default     = false
  description = "Also install Rancher and setup SSO for NeuVector"
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
  default     = "neuvector-quickstart"
}

variable "aws_zone" {
  type        = string
  description = "AWS zone used for all resources"
  default     = "us-east-1b"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3a.xlarge"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use"
  default     = "v1.24.14+rke2r1"
}

variable "neuvector_chart_version" {
  type        = string
  description = "NeuVector helm chart version"
  default     = "2.6.1"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside NeuVector (format: 0.0.0)"
  default     = "1.11.0"
}

variable "rancher_version" {
  type        = string
  description = "Rancher version"
  default     = "2.7.9"
}

variable "rancher_helm_repository" {
  type        = string
  description = "The helm repository, where the Rancher helm chart is installed from"
  default     = "https://releases.rancher.com/server-charts/latest"
}

# Local variables used to reduce repetition
locals {
  node_username = "ec2-user"
}
