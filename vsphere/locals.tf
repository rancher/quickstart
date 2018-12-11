locals {
  server_name_prefix = "rancher-qs-server"
  cluster_nodes_name_prefix = "rancher-qs-node"

  # Support either of cluster or host name
  # pool_id = "${var.vsphere_cluster != "" ? join("", data.vsphere_compute_cluster.cluster.*.resource_pool_id) : join("", data.vsphere_host.host.*.resource_pool_id)}"
  # Support either of cluster or resource pool name
  pool_id = "${var.vsphere_cluster != "" ? join("", data.vsphere_compute_cluster.cluster.*.resource_pool_id) : join("", data.vsphere_resource_pool.pool.*.id)}"
}