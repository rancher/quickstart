# Renders the userdata for the server
data "template_file" "userdata_server" {
  template = "${file("${path.module}/files/userdata_server")}"

  vars {
    admin_password  = "${var.rancher_admin_password}"
    cluster_name    = "${var.rancher_cluster_name}"
    docker_version  = "${var.docker_version}"
    rancher_version = "${var.rancher_version}"
  }
}

# Renders the userdata for the cluster nodes
data "template_file" "userdata_agent" {
  template = "${file("${path.module}/files/userdata_agent")}"

  vars {
    admin_password  = "${var.rancher_admin_password}"
    cluster_name    = "${var.rancher_cluster_name}"
    docker_version  = "${var.docker_version}"
    rancher_version = "${var.rancher_version}"
    server_address  = "${vsphere_virtual_machine.server.default_ip_address}"
  }
}
