data "vsphere_datacenter" "dc" {
  name = "${var.vsphere_datacenter}"
}

# Use count with tenary operator for conditional fetching of this data source
data "vsphere_compute_cluster" "cluster" {
  count         = "${var.vsphere_cluster != "" ? 1 : 0}"
  name          = "${var.vsphere_cluster}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Use count with tenary operator for conditional fetching of this data source
data "vsphere_host" "host" {
  count         = "${var.vsphere_host != "" ? 1 : 0}"
  name          = "${var.vsphere_host}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_datastore" "datastore" {
  name          = "${var.vsphere_datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "${var.vsphere_network}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_template}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
