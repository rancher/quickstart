# Creates the VM inventory folder
resource "vsphere_folder" "folder" {
  path          = "${var.vsphere_folder}"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Creates and provisions a VM for the server
resource "vsphere_virtual_machine" "server" {
  name             = "${local.server_name_prefix}"
  resource_pool_id = "${local.pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "${var.vsphere_folder}"

  num_cpus = 2
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
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
      "guestinfo.cloud-init.config.data" = "${base64encode("${data.template_file.server.rendered}")}"
      "guestinfo.cloud-init.data.encoding" = "base64"
    }
  }

  # Copy script to bootstrap Rancher server
  provisioner "file" {
    source      = "${path.module}/files/server_bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
    connection {
      type        = "ssh"
      user        = "rancher"
      private_key = "${tls_private_key.provisioning_key.private_key_pem}"
    }
  }

  # Execute bootstrap script and provision user SSH key
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "/tmp/bootstrap.sh \"${var.rancher_admin_password}\"",
      "sudo echo \"${var.authorized_ssh_key}\" > /home/rancher/.ssh/authorized_keys",
      "sudo ros config set ssh_authorized_keys ['${var.authorized_ssh_key}']",
    ]

    connection {
      type        = "ssh"
      user        = "rancher"
      private_key = "${tls_private_key.provisioning_key.private_key_pem}"
    }
  }
}

# Creates and provisions VMs for the cluster
resource "vsphere_virtual_machine" "nodes" {
  count            = "${var.rancher_num_cluster_nodes}"
  name             = "${local.cluster_nodes_name_prefix}-${count.index + 1}"
  resource_pool_id = "${local.pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "${var.vsphere_folder}"

  //num_cpus = "${var.node_num_cpus}"
  //memory   = "${var.node_memory_gb}"
  num_cpus = 2
  memory   = 4096
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type = "${data.vsphere_virtual_machine.template.scsi_type}"

  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
    adapter_type = "${data.vsphere_virtual_machine.template.network_interface_types[0]}"
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
      "guestinfo.cloud-init.config.data" = "${base64encode("${data.template_file.cluster.*.rendered[count.index]}")}"
      "guestinfo.cloud-init.data.encoding" = "base64"
    }
  }

  # Copy script to bootstrap Rancher agent
  provisioner "file" {
    source      = "${path.module}/files/agent_bootstrap.sh"
    destination = "/tmp/bootstrap.sh"
    connection {
      type        = "ssh"
      user        = "rancher"
      private_key = "${tls_private_key.provisioning_key.private_key_pem}"
    }
  }

  # Execute bootstrap script and provision user SSH key
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "/tmp/bootstrap.sh \"${vsphere_virtual_machine.server.default_ip_address}\" \"${var.rancher_admin_password}\"",
      "sudo echo \"${var.authorized_ssh_key}\" > /home/rancher/.ssh/authorized_keys",
      "sudo ros config set ssh_authorized_keys ['${var.authorized_ssh_key}']",
    ]

    connection {
      type        = "ssh"
      user        = "rancher"
      private_key = "${tls_private_key.provisioning_key.private_key_pem}"
    }
  }
}
