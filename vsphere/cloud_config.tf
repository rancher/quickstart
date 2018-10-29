# Renders the cloud-config file for the server
data "template_file" "server" {
  template = "${file("${path.module}/files/cloud-config-server.tpl")}"

  vars {
    authorized_key = "${tls_private_key.provisioning_key.public_key_openssh}"
    hostname = "${local.server_name_prefix}"
    docker_version = "${var.node_docker_version}"
    rancher_version= "${var.rancher_version}"
  }
}

# Renders the cloud-config file for the cluster nodes
data "template_file" "cluster" {
  template = "${file("${path.module}/files/cloud-config-cluster.tpl")}"
  count    = "${var.rancher_num_cluster_nodes}"

  vars {
    authorized_key = "${tls_private_key.provisioning_key.public_key_openssh}"
    hostname = "${local.cluster_nodes_name_prefix}-${count.index + 1}"
    docker_version = "${var.node_docker_version}"
  }
}