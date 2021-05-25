# Linode infrastructure resources

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
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

# Temporary key pair used for SSH accesss
resource "linode_sshkey" "quickstart_ssh_key" {
  label   = "${var.prefix}-rancher-ssh-key"
  ssh_key = replace(tls_private_key.global_key.public_key_openssh, "\n", "")
}

resource "linode_stackscript" "rancher_server" {
  label       = "rancher-server"
  description = "Rancher server launch script"
  script = templatefile(
    join("/", [path.module, "../cloud-common/files/userdata_rancher_server.template"]),
    {
      docker_version = var.docker_version
      username       = local.node_username
    }
  )

  images   = ["linode/ubuntu18.04"]
  rev_note = "initial version"
}

# Linode for creating a single node RKE cluster and installing the Rancher server
resource "linode_instance" "rancher_server" {
  label           = "${var.prefix}-rancher-server"
  image           = "linode/ubuntu18.04"
  region          = var.linode_region
  type            = var.linode_type
  authorized_keys = [linode_sshkey.quickstart_ssh_key.ssh_key]

  stackscript_id = linode_stackscript.rancher_server.id
}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip         = linode_instance.rancher_server.ip_address
  node_internal_ip       = linode_instance.rancher_server.private_ip_address
  node_username          = local.node_username
  ssh_private_key_pem    = tls_private_key.global_key.private_key_pem
  rke_kubernetes_version = var.rke_kubernetes_version

  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version

  rancher_server_dns = join(".", ["rancher", linode_instance.rancher_server.ip_address, "xip.io"])
  admin_password     = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-linode-custom"
}

# Linode stackscript to initialise node
resource "linode_stackscript" "quickstart_node" {
  label       = "workload-node"
  description = "Quickstart launch script"
  script = templatefile(
    join("/", [path.module, "../cloud-common/files/userdata_quickstart_node.template"]),
    {
      docker_version   = var.docker_version
      username         = local.node_username
      register_command = module.rancher_common.custom_cluster_command
    }
  )

  images   = ["linode/ubuntu18.04"]
  rev_note = "initial version"
}

# Linode for creating a single node workload cluster
resource "linode_instance" "quickstart_node" {
  label           = "${var.prefix}-workload-node"
  image           = "linode/ubuntu18.04"
  region          = var.linode_region
  type            = var.linode_type
  authorized_keys = [linode_sshkey.quickstart_ssh_key.ssh_key]

  stackscript_id = linode_stackscript.quickstart_node.id
}
