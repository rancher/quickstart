# Configure the vSphere Provider
provider "vsphere" {
  version        = "~> 1.8"
  user           = "${var.vcenter_user}"
  password       = "${var.vcenter_password}"
  vsphere_server = "${var.vcenter_server}"
  allow_unverified_ssl = "${var.vcenter_insecure}"
}
