provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server
  allow_unverified_ssl = var.vsphere_server_allow_unverified_ssl
}

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vsphere_virtual_machine
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "rke" {
  name = "${var.prefix}-rke-h${count.index + 1}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  count = var.rke_node_count
  num_cpus  = var.vm_cpus
  memory    = var.vm_memory
  guest_id  = data.vsphere_virtual_machine.template.guest_id
  scsi_type = data.vsphere_virtual_machine.template.scsi_type
  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }
  cdrom {
    client_device = true
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }
  vapp {
    properties = {
      user-data = base64encode(templatefile("${path.module}/cloud-init.template", {
          node_name = "${var.prefix}-rke-h${count.index + 1}",
          authorized_keys = var.authorized_keys
        }
      ))
      hostname = "${var.prefix}-rke-h${count.index + 1}"
    }
  }
  disk {
    label            = "disk0"
    size             = 80
    unit_number      = 0
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }

  connection {
    host = self.default_ip_address
    type     = "ssh"
    user     = var.vm_username
    private_key = file(pathexpand(var.ssh_private_key_path))
  }

  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive;curl -sSL https://raw.githubusercontent.com/rancher/install-docker/master/${var.docker_version}.sh | sh -",
      "sudo usermod -aG docker ubuntu"
    ]
  }
}
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip = null
  rancher_nodes = [
  for index, x in vsphere_virtual_machine.rke[*] : {
    public_ip = vsphere_virtual_machine.rke[index].default_ip_address
    private_ip = ""
    roles = ["etcd", "controlplane", "worker"]
  }
  ]
  node_username          = var.vm_username
  ssh_private_key_pem    = var.ssh_private_key_path
  rke_kubernetes_version = var.rke_kubernetes_version

  ingress_tls_source = var.ingress_tls_source
  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version

  rancher_server_dns = join(".", [vsphere_virtual_machine.rke[0].default_ip_address, var.domain_for_rancher])

  admin_password = var.rancher_server_admin_password

  create_workload_cluster = var.create_workload_cluster
  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = var.workload_cluster_name
}
