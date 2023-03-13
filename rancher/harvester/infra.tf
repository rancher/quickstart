# Harvester infrastructure resources

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
  name       = "${var.prefix}-vm-ssh-key"
  public_key = trimspace(tls_private_key.global_key.public_key_openssh)
}

# Ubuntu image used for Rancher server
resource "harvester_image" "ubuntu20" {
  name      = "${var.prefix}-ubuntu20"
  namespace = "harvester-public"

  display_name = "ubuntu-20.04-server-cloudimg-amd64.img"
  source_type  = "download"
  url          = "http://cloud-images.ubuntu.com/releases/focal/release/ubuntu-20.04-server-cloudimg-amd64.img"
}

data "harvester_network" "rancher" {
  name      = var.network_name
  namespace = var.namespace
}

resource "harvester_virtualmachine" "rancher_server" {
  name                 = "${var.prefix}-rancher-server"
  namespace            = var.namespace
  restart_after_update = true

  description = "Rancher server"
  tags = {
    ssh-user = "ubuntu"
  }

  cpu    = 2
  memory = "4Gi"

  efi         = true
  secure_boot = true

  run_strategy = "RerunOnFailure"
  hostname     = "${var.prefix}-rancher-server"
  machine_type = "q35"

  ssh_keys = [
    harvester_ssh_key.quickstart_ssh_key.id
  ]

  network_interface {
    name           = "nic-1"
    network_name   = data.harvester_network.rancher.id
    wait_for_lease = true
  }

  disk {
    name       = "rootdisk"
    type       = "disk"
    size       = "40Gi"
    bus        = "virtio"
    boot_order = 1

    image       = harvester_image.ubuntu20.id
    auto_delete = true
  }

  cloudinit {
    user_data = <<-EOF
      #cloud-config
      ssh_pwauth: true
      package_update: true
      packages:
        - qemu-guest-agent
      runcmd:
        - - systemctl
          - enable
          - '--now'
          - qemu-guest-agent
      ssh_authorized_keys:
        - ${harvester_ssh_key.quickstart_ssh_key.public_key}
      EOF
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.network_interface[0].ip_address
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
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
  workload_cluster_name       = "quickstart-harvester-custom"
}

resource "harvester_virtualmachine" "quickstart_node" {
  name                 = "${var.prefix}-quickstart-node"
  namespace            = "default"
  restart_after_update = true

  description = "rancher quickstart node"
  tags = {
    ssh-user = "ubuntu"
  }

  cpu    = 2
  memory = "4Gi"

  efi         = true
  secure_boot = true

  run_strategy = "RerunOnFailure"
  hostname     = "${var.prefix}-quickstart-node"
  machine_type = "q35"

  ssh_keys = [
    harvester_ssh_key.quickstart_ssh_key.id
  ]

  network_interface {
    name           = "nic-1"
    network_name   = data.harvester_network.rancher.id
    wait_for_lease = true
  }

  disk {
    name       = "rootdisk"
    type       = "disk"
    size       = "40Gi"
    bus        = "virtio"
    boot_order = 1

    image       = harvester_image.ubuntu20.id
    auto_delete = true
  }

  cloudinit {
    user_data = <<-EOF
      #cloud-config
      ssh_pwauth: true
      package_update: true
      packages:
        - qemu-guest-agent
      runcmd:
        - - systemctl
          - enable
          - '--now'
          - qemu-guest-agent
        - ${local.cluster_node_command}
      ssh_authorized_keys:
        - ${harvester_ssh_key.quickstart_ssh_key.public_key}
      EOF
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.network_interface[0].ip_address
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}
