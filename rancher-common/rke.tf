# RKE resources

# Provision RKE cluster on provided infrastructure
resource "rke_cluster" "rancher_cluster" {
  cluster_name = "quickstart-rancher-server"

  nodes {
    address          = var.node_public_ip
    internal_address = var.node_internal_ip
    user             = var.node_username
    role             = ["controlplane", "etcd", "worker"]
    ssh_key          = file(var.ssh_key_file_name)
  }

  kubernetes_version = var.rke_kubernetes_version
}

