# Variables for OpenStack infrastructure module

variable "openstack_floating_ip_pool" {
  type        = string
  description = "The name of the pool from which to obtain the floating IPs."
}

variable "openstack_auth_url" {
  type        = string
  description = "The OpenStack Identity authentication URL"
  default     = null
}

variable "openstack_cloud" {
  type        = string
  description = "The entry in a clouds.yaml file."
  default     = null
}

variable "openstack_region" {
  type        = string
  description = "The region of the OpenStack cloud to use."
  default     = null
}

variable "openstack_user_name" {
  type        = string
  description = "The Username to login with."
  default     = null
}

variable "openstack_project_name" {
  type        = string
  description = "The Name of the Project."
  default     = null
}

variable "openstack_password" {
  type        = string
  description = "The Password to login with."
  default     = null
}

variable "openstack_domain_name" {
  type        = string
  description = "The Name of the Domain to scope to."
  default     = null
}

variable "openstack_user_id" {
  type        = string
  description = "The User ID to login with."
  default     = null
}

variable "openstack_application_credential_id" {
  type        = string
  description = "The ID of an application credential to authenticate with."
  default     = null
}

variable "openstack_application_credential_name" {
  type        = string
  description = "The name of an application credential to authenticate with."
  default     = null
}

variable "openstack_application_credential_secret" {
  type        = string
  description = "The secret of an application credential to authenticate with."
  default     = null
}

variable "openstack_project_id" {
  type        = string
  description = "The ID of the Project to login with."
  default     = null
}

variable "openstack_token" {
  type        = string
  description = "The auth token to login with."
  default     = null
}

variable "openstack_user_domain_name" {
  type        = string
  description = "The domain name where the user is located."
  default     = null
}

variable "openstack_user_domain_id" {
  type        = string
  description = "The domain ID where the user is located."
  default     = null
}

variable "openstack_project_domain_name" {
  type        = string
  description = "The domain name where the project is located."
  default     = null
}

variable "openstack_project_domain_id" {
  type        = string
  description = "The domain ID where the project is located."
  default     = null
}

variable "openstack_domain_id" {
  type        = string
  description = "The Name of the Domain to scope to."
  default     = null
}

variable "openstack_insecure" {
  type        = bool
  description = "Trust self-signed SSL certificates."
  default     = null
}

variable "openstack_cacert_file" {
  type        = string
  description = "Specify a custom CA certificate when communicating over SSL."
  default     = null
}

variable "openstack_cert" {
  type        = string
  description = "Specify client certificate file for SSL client authentication."
  default     = null
}

variable "openstack_key" {
  type        = string
  description = "Specify client private key file for SSL client authentication."
  default     = null
}

variable "prefix" {
  type        = string
  description = "Prefix added to names of all resources"
  default     = "quickstart"
}

variable "instance_type" {
  type        = string
  description = "Instance type used for all linux virtual machines"
  default     = "m1.large"
}

variable "docker_version" {
  type        = string
  description = "Docker version to install on nodes"
  default     = "19.03"
}

variable "rke_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for Rancher server RKE cluster"
  default     = "v1.18.6-rancher1-1"
}

variable "workload_kubernetes_version" {
  type        = string
  description = "Kubernetes version to use for managed workload cluster"
  default     = "v1.17.9-rancher1-1"
}

variable "cert_manager_version" {
  type        = string
  description = "Version of cert-mananger to install alongside Rancher (format: 0.0.0)"
  default     = "0.15.1"
}

variable "rancher_version" {
  type        = string
  description = "Rancher server version (format: v0.0.0)"
  default     = "v2.4.6"
}

variable "network_cidr" {
  type        = string
  description = "The Network CIDR for the Rancher nodes"
  default     = "10.0.0.0/16"
}

# Required
variable "rancher_server_admin_password" {
  type        = string
  description = "Admin password to use for Rancher server bootstrap"
}


# Local variables used to reduce repetition
locals {
  node_username = "ubuntu"
}
