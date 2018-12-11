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

# Number of nodes to create for the first cluster
variable "rancher_num_cluster_nodes" {
  default = 3
}

# Name the first cluster
variable "rancher_cluster_name" {
  default = "quickstart"
}

#-----------------------------------------#
# Node Configuration
#-----------------------------------------#

// Number of vCPUs to assign to worker nodes
variable "node_num_cpus" {
  default = "2"
}

// Memory size in MB to assign to worker nodes
variable "node_memory_mb" {
  default = "4096"
}

// Docker version to install on VMs
variable "docker_version" {
  default = "17.03"
}

#-----------------------------------------#
# vSphere Resource Configuration
#-----------------------------------------#

# vSphere datacenter to use
variable "vsphere_datacenter" {
  type = "string"
}

# vSphere cluster to use (required unless vsphere_resource_pool is specified)
variable "vsphere_cluster" {
  type = "string"
  default = ""
}

# vSphere resource pool to use (required unless vsphere_cluster is specified)
variable "vsphere_resource_pool" {
  type = "string"
  default = ""
}

# vSphere host to use (required unless vsphere_cluster or vsphere_resource_pool are specified)
# variable "vsphere_host" {
#   type = "string"
#   default = ""
# }

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

# Name/path of virtual machine folder to store the VMs in.
# The folder must not exist already.
variable "vsphere_folder" {
  default= "rancher-quickstart"
}

#-----------------------------------------#
# Management
#-----------------------------------------#

# SSH public key to authorize for SSH access of the nodes
variable "authorized_ssh_key" {
  type = "string"
}
