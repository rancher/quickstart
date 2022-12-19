# DO infrastructure resources

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "ssh_private_key_pem" {
  filename        = "${path.module}/id_rsa"
  content         = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

# Temporary key pair used for SSH accesss
resource "harvester_ssh_key" "quickstart_ssh_key" {
  name       = "${var.prefix}-droplet-ssh-key"
  public_key = tls_private_key.global_key.public_key_openssh
}

# Ubuntu image used for Rancher server
resource "harvester_image" "ubuntu20" {
  name      = "ubuntu20"
  namespace = "harvester-public"

  display_name = "ubuntu-20.04-server-cloudimg-amd64.img"
  source_type  = "download"
  url          = "http://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
}

# DO droplet for creating a single node RKE cluster and installing the Rancher server
# resource "harvester_virtualmachine" "rancher_server" {
#   name     = "${var.prefix}-rancher-server"
#   image    = "ubuntu-20-04-x64"
#   region   = var.do_region
#   size     = var.droplet_size
#   ssh_keys = [harvester_ssh_key.quickstart_ssh_key.fingerprint]

#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Waiting for cloud-init to complete...'",
#       "cloud-init status --wait > /dev/null",
#       "echo 'Completed cloud-init!'",
#     ]

#     connection {
#       type        = "ssh"
#       host        = self.ipv4_address
#       user        = local.node_username
#       private_key = tls_private_key.global_key.private_key_pem
#     }
#   }
# }

data "harvester_network" "rancher" {
  name      = "vms"
  namespace = "default"
}

resource "harvester_virtualmachine" "rancher_server" {
  name                 = "ubuntu20"
  namespace            = "default"
  restart_after_update = true

  description = "test ubuntu20 raw image"
  tags = {
    ssh-user = "ubuntu"
  }

  cpu    = 2
  memory = "2Gi"

  efi         = true
  secure_boot = true

  run_strategy = "RerunOnFailure"
  hostname     = "ubuntu20"
  machine_type = "q35"

  ssh_keys = [
    harvester_ssh_key.quickstart_ssh_key.fingerprint
  ]

  network_interface {
    name           = "nic-1"
    network_name = data.harvester_network.rancher.id
    wait_for_lease = true
  }

  disk {
    name       = "rootdisk"
    type       = "disk"
    size       = "10Gi"
    bus        = "virtio"
    boot_order = 1

    image       = harvester_image.ubuntu20.id
    auto_delete = true
  }

  # disk {
  #   name        = "emptydisk"
  #   type        = "disk"
  #   size        = "20Gi"
  #   bus         = "virtio"
  #   auto_delete = true
  # }

  # cloudinit {
  #   user_data    = <<-EOF
  #     #cloud-config
  #     password: 123456
  #     chpasswd:
  #       expire: false
  #     ssh_pwauth: true
  #     package_update: true
  #     packages:
  #       - qemu-guest-agent
  #     runcmd:
  #       - - systemctl
  #         - enable
  #         - '--now'
  #         - qemu-guest-agent
  #     EOF
  #   network_data = ""
  # }
}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip             = harvester_virtualmachine.rancher_server.network_interface[0].ip_address
  node_internal_ip           = harvester_virtualmachine.rancher_server.network_interface[0].ip_address
  node_username              = local.node_username
  ssh_private_key_pem        = tls_private_key.global_key.private_key_pem
  rancher_kubernetes_version = var.rancher_kubernetes_version

  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version

  rancher_server_dns = join(".", ["rancher", harvester_virtualmachine.rancher_server.network_interface[0].ip_address, "sslip.io"])
  admin_password     = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-do-custom"
}

# DO droplet for creating a single node workload cluster
# resource "digitalocean_droplet" "quickstart_node" {
#   name     = "${var.prefix}-quickstart-node"
#   image    = "ubuntu-20-04-x64"
#   region   = var.do_region
#   size     = var.droplet_size
#   ssh_keys = [digitalocean_ssh_key.quickstart_ssh_key.fingerprint]

#   user_data = templatefile(
#     "${path.module}/files/userdata_quickstart_node.template",
#     {
#       register_command = module.rancher_common.custom_cluster_command
#     }
#   )

#   provisioner "remote-exec" {
#     inline = [
#       "echo 'Waiting for cloud-init to complete...'",
#       "cloud-init status --wait > /dev/null",
#       "echo 'Completed cloud-init!'",
#     ]

#     connection {
#       type        = "ssh"
#       host        = self.ipv4_address
#       user        = local.node_username
#       private_key = tls_private_key.global_key.private_key_pem
#     }
#   }
# }
