# Scaleway infrastructure resources

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
resource "scaleway_account_ssh_key" "quickstart_ssh_key" {
  name       = "${var.prefix}-instance-ssh-key"
  public_key = tls_private_key.global_key.public_key_openssh
}

# Scaleway instance for creating a single node RKE cluster and installing the Rancher server
resource "scaleway_instance_server" "rancher_server" {
  name              = "${var.prefix}-rancher-server"
  image             = "ubuntu_focal"
  type              = var.instance_type
  enable_dynamic_ip = true

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip             = scaleway_instance_server.rancher_server.public_ip
  node_internal_ip           = scaleway_instance_server.rancher_server.private_ip
  node_username              = local.node_username
  ssh_private_key_pem        = tls_private_key.global_key.private_key_pem
  rancher_kubernetes_version = var.rancher_kubernetes_version

  cert_manager_version    = var.cert_manager_version
  rancher_version         = var.rancher_version
  rancher_helm_repository = var.rancher_helm_repository

  rancher_server_dns = join(".", ["rancher", scaleway_instance_server.rancher_server.public_ip, "sslip.io"])
  admin_password     = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-scw-custom"
}

# Scaleway instance for creating a single node workload cluster
resource "scaleway_instance_server" "quickstart_node" {
  name              = "${var.prefix}-quickstart-node"
  image             = "ubuntu_focal"
  type              = var.instance_type
  enable_dynamic_ip = true

  user_data = {
    cloud-init = templatefile(
      join("/", [path.module, "files/userdata_quickstart_node.template"]),
      {
        username         = local.node_username
        register_command = module.rancher_common.custom_cluster_command
      }
    )
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}
