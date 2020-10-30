# RKE resources

# Provision RKE cluster on provided infrastructure
resource "rke_cluster" "rancher_cluster" {
  cluster_name = "quickstart-rancher-server"

  dynamic nodes {
    for_each = var.rancher_nodes == null ? [1] : []
    content {
      address          = var.node_public_ip
      internal_address = var.node_internal_ip
      user             = var.node_username
      role             = ["controlplane", "etcd", "worker"]
      ssh_key          = file(pathexpand(var.ssh_private_key_pem))
    }
  }

  dynamic nodes {
    for_each = var.rancher_nodes != null ? var.rancher_nodes : []
    content {
      address          = nodes.value.public_ip
      internal_address = nodes.value.private_ip
      role             = nodes.value.roles
      user             = var.node_username
      ssh_key          = file(var.ssh_private_key_pem)
    }
  }

  kubernetes_version = var.rke_kubernetes_version

  dynamic "private_registries" {
    for_each = var.private_registry_url != null ? [1]: []
    content {
      url = var.private_registry_url
      user = var.private_registry_username
      password = var.private_registry_password
      is_default = true
    }
  }

}

