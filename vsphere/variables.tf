#-----------------------------------------#
# vCenter Connection
#-----------------------------------------#

# vCenter username
variable "vcenter_user" {
  type = "string"
}

# vCenter password
variable "vcenter_password" {
  type = "string"
}

# vCenter server FQDN or IP address
variable "vcenter_server" {
  type = "string"
}

// Skip certificate verification
variable "vcenter_insecure" {
  default = false
}

#-----------------------------------------#
# Rancher Configuration
#-----------------------------------------#

# Rancher admin password to use
variable "rancher_admin_password" {
  type = "string"
}

# Rancher image tag/version to use
variable "rancher_version" {
  default = "latest"
}

# Number of nodes to create for first cluster
variable "rancher_num_cluster_nodes" {
  default = 3
}

#-----------------------------------------#
# Cluster Node Configuration
#-----------------------------------------#

// Number of vCPUs to assign to cluster nodes
variable "node_num_cpus" {
  default = 2
}

// Memory size in GB to assign to cluster nodes
variable "node_memory_gb" {
  default = 2
}

// Docker version to use for nodes
variable "node_docker_version" {
  default = "17.03.1-ce"
}

#-----------------------------------------#
# vSphere Resource Configuration
#-----------------------------------------#

# vSphere datacenter to use
variable "vsphere_datacenter" {
  type = "string"
}

# vSphere cluster to use (required unless vsphere_host is specified)
variable "vsphere_cluster" {
  type = "string"
  default = ""
}

# vSphere host to use (required unless vsphere_cluster is specified)
variable "vsphere_host" {
  type = "string"
  default = ""
}

# Name/path of datastore to use
variable "vsphere_datastore" {
  type = "string"
}

# VM Network to attach the VMs
variable "vsphere_network" {
  type = "string"
}

# Name/path of RancherOS template to clone VMs from
variable "vsphere_template" {
  type = "string"
}

# Name/path of inventory folder in which to store the VMs
variable "vsphere_folder" {
  default= "rancher-quickstart"
}

#-----------------------------------------#
# Management
#-----------------------------------------#

# SSH public key to authorize on all VMs
variable "authorized_ssh_key" {
  type = "string"
}
