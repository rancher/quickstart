locals {
  server_name_prefix = "rancher-qs-server"
  cluster_nodes_name_prefix = "rancher-qs-node"
  # Some trickery to work around limitation of terrafom tenary operator
  # Allows the user to specify either the name of a cluster or an ESXi host
  pool_id = "${var.vsphere_cluster != "" ? join("", data.vsphere_compute_cluster.cluster.*.resource_pool_id) : join("", data.vsphere_host.host.*.resource_pool_id)}"
}
