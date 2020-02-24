# DO infrastructure resources

# Temporary key pair used for SSH accesss
resource "digitalocean_ssh_key" "quickstart_ssh_key" {
  name       = "${var.prefix}-droplet-ssh-key"
  public_key = file("${var.ssh_key_file_name}.pub")
}

# DO droplet for creating a single node RKE cluster and installing the Rancher server
resource "digitalocean_droplet" "rancher_server" {
  name               = "${var.prefix}-rancher-server"
  image              = "ubuntu-18-04-x64"
  region             = var.do_region
  size               = var.droplet_size
  ssh_keys           = [digitalocean_ssh_key.quickstart_ssh_key.fingerprint]
  private_networking = true

  user_data = templatefile("../cloud-common/files/userdata_rancher_server.template", {
    docker_version = var.docker_version
    username       = local.node_username
  })

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type        = "ssh"
      host        = self.ipv4_address
      user        = local.node_username
      private_key = file(var.ssh_key_file_name)
    }
  }
}

locals {
  # SSL certs can only use DNS names as hosts; use xip.io as a placeholder DNS name
  droplet_dns = join(".", ["rancher", digitalocean_droplet.rancher_server.ipv4_address, "xip.io"])
}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip         = digitalocean_droplet.rancher_server.ipv4_address
  node_internal_ip       = digitalocean_droplet.rancher_server.ipv4_address_private
  node_username          = local.node_username
  ssh_key_file_name      = var.ssh_key_file_name
  rke_kubernetes_version = var.rke_kubernetes_version

  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version

  rancher_server_dns = local.droplet_dns
  admin_password     = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-do-custom"
}

# DO droplet for creating a single node workload cluster
resource "digitalocean_droplet" "quickstart_node" {
  name               = "${var.prefix}-quickstart-node"
  image              = "ubuntu-18-04-x64"
  region             = var.do_region
  size               = var.droplet_size
  ssh_keys           = [digitalocean_ssh_key.quickstart_ssh_key.fingerprint]
  private_networking = true

  user_data = templatefile("../cloud-common/files/userdata_quickstart_node.template", {
    docker_version   = var.docker_version
    username         = local.node_username
    register_command = module.rancher_common.custom_cluster_command
  })

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type        = "ssh"
      host        = self.ipv4_address
      user        = local.node_username
      private_key = file(var.ssh_key_file_name)
    }
  }
}
