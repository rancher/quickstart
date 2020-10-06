# Local resources

# Save kubeconfig file for interacting with the RKE cluster on your local machine
resource "local_file" "kube_config_server_yaml" {
  depends_on = [
    rke_cluster.rancher_cluster,
  ]
  filename = format("%s/%s", path.root, "kube_config_server.yaml")
  content  = rke_cluster.rancher_cluster.kube_config_yaml
}

resource "local_file" "kube_config_workload_yaml" {
  depends_on = [
    rancher2_cluster.quickstart_workload[0],
  ]
  count = var.create_workload_cluster ? 1 : 0
  filename = format("%s/%s", path.root, "kube_config_workload.yaml")
  content  = rancher2_cluster.quickstart_workload[0].kube_config
}
