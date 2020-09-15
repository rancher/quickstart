# SCW Infrastructure resources

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "ssh_private_key_pem" {
  filename          = "${path.module}/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission   = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

resource "scaleway_account_ssh_key" "main" {
    name        = "${var.prefix}-droplet-ssh-key"
    public_key = tls_private_key.global_key.public_key_openssh
}

# SCW Public Compute Address for rancher server node
resource "scaleway_instance_ip" "public_ip" {}

# Firewall Rule to allow all traffic
resource "scaleway_instance_security_group" "rancher_fw_allowall" {
  name                    = "${var.prefix}-rancher-allowall"
  description             = "rancher allow all"

  inbound_default_policy  = "accept"
  outbound_default_policy = "accept"
}

resource "scaleway_instance_server" "rancher_server" {
  depends_on = [
    scaleway_instance_security_group.rancher_fw_allowall,
  ]

  name         = "${var.prefix}-rancher-server"
  type         = var.machine_type
  image        = "centos_7.6"

  ip_id        = scaleway_instance_ip.public_ip.id

  security_group_id = scaleway_instance_security_group.rancher_fw_allowall.id

  cloud_init = templatefile(
    join("/", [path.module, "../cloud-common/files/userdata_rancher_server.template"]),
    {
      docker_version = var.docker_version
      username       = local.node_username
    }
  )

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = scaleway_instance_ip.public_ip.address
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip         = scaleway_instance_server.rancher_server.public_ip
  node_internal_ip       = scaleway_instance_server.rancher_server.private_ip
  node_username          = local.node_username
  ssh_private_key_pem    = tls_private_key.global_key.private_key_pem
  rke_kubernetes_version = var.rke_kubernetes_version

  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version

  rancher_server_dns = join(".", ["rancher", scaleway_instance_server.rancher_server.public_ip, "xip.io"])
  admin_password     = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-gcp-custom"
}

