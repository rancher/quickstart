# Creates the VM inventory folder
resource "vsphere_folder" "folder" {
  path          = "${var.vsphere_folder}"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Generate UUIDs for all VMs to pass to Cloud-Init
resource "random_uuid" "instance-id" {
  count = "${var.rancher_num_cluster_nodes +1}"
}

# Creates and provisions a VM for the server
resource "vsphere_virtual_machine" "server" {
  name             = "${local.server_name_prefix}"
  resource_pool_id = "${local.pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "${vsphere_folder.folder.path}"

  num_cpus  = 2
  memory    = 4096
  guest_id  = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  # Required for OVF ISO transport
  cdrom {
    client_device = true
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone  = false
  }

  vapp {
    properties {
      "instance-id" = "${random_uuid.instance-id.*.result[0]}"
      "hostname"    = "${local.server_name_prefix}"
      "public-keys" = "${var.authorized_ssh_key}"
      "user-data"   = "${base64encode("${data.template_file.userdata_server.rendered}")}"
    }
  }
}

# Creates and provisions VMs for the cluster
resource "vsphere_virtual_machine" "nodes" {
  count            = "${var.rancher_num_cluster_nodes}"
  name             = "${local.cluster_nodes_name_prefix}-${count.index + 1}-all"
  resource_pool_id = "${local.pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "${var.vsphere_folder}"

  num_cpus  = "${var.node_num_cpus}"
  memory    = "${var.node_memory_mb}"
  guest_id  = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
  }

  # Required for OVF ISO transport
  cdrom {
    client_device = true
  }

  disk {
    label            = "disk0"
    size             = "${data.vsphere_virtual_machine.template.disks.0.size}"
    eagerly_scrub    = "${data.vsphere_virtual_machine.template.disks.0.eagerly_scrub}"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    linked_clone  = false
  }

  vapp {
    properties {
      "instance-id" = "${random_uuid.instance-id.*.result[count.index+1]}"
      "hostname"    = "${local.cluster_nodes_name_prefix}-${count.index + 1}-all"
      "public-keys" = "${var.authorized_ssh_key}"
      "user-data"   = "${base64encode("${data.template_file.userdata_agent.rendered}")}"
    }
  }
}
