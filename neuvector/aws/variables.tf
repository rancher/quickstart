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
}

variable "install_rancher" {
  type        = bool
  default     = false
  description = "Also install Rancher and setup SSO for NeuVector"
}

variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap"
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

variable "instance_type" {
  type        = string
  description = "Instance type used for all EC2 instances"
  default     = "t3a.xlarge"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to use"
  default     = "v1.22.10-rc2+rke2r1"
}

variable "neuvector_chart_version" {
  type        = string
  description = "NeuVector helm chart version"
  default     = "2.2.0"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-manager to install alongside NeuVector (format: 0.0.0)"
  default     = "1.7.1"
}

variable "rancher_version" {
  type        = string
  description = "Rancher version"
  default     = "2.6.5"
}

# Local variables used to reduce repetition
locals {
  node_username = "ec2-user"
}
