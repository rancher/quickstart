provider "linode" {
  token = var.linode_token
}

data "linode_domain" "linode_domain_for_rancher" {
  domain = var.linode_domain_for_rancher
}

resource "linode_nodebalancer" "rke-lb" {
  label = "${var.prefix}-rke"
  region = var.region
}

resource "linode_nodebalancer_config" "rke-lb-config" {
  nodebalancer_id = linode_nodebalancer.rke-lb.id
  port = 443
  protocol = "tcp"
  check = "connection"
  check_attempts = 2
  check_timeout = 3
  check_interval = 5
  stickiness = "table"
  algorithm = "roundrobin"
}

resource "linode_nodebalancer_node" "rke-lb-node" {
  count = var.rke_node_count
  nodebalancer_id = linode_nodebalancer.rke-lb.id
  config_id = linode_nodebalancer_config.rke-lb-config.id
  label = "${var.prefix}-rke-h${count.index + 1}"
  address = "${element(linode_instance.rke.*.private_ip_address, count.index)}:443"
  mode = "accept"
}

resource "linode_domain_record" "rancher_dns_record" {
  domain_id = data.linode_domain.linode_domain_for_rancher.id
  name = var.rancher_server_name
  record_type = "A"
  target = linode_nodebalancer.rke-lb.ipv4
  ttl_sec = "300"
}

resource "linode_instance" "rke" {
  count = var.rke_node_count
  image = var.instance_image
  label = "${var.prefix}-rke-h${count.index + 1}"
  region = var.region
  type = var.instance_type
  authorized_keys = var.authorized_keys
  root_pass = var.root_password
  private_ip = true

  connection {
    host = self.ip_address
    type     = "ssh"
    user     = var.node_username
    private_key = file(pathexpand(var.ssh_private_key_path))
  }

  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive;curl -sSL https://raw.githubusercontent.com/rancher/install-docker/master/${var.docker_version}.sh | sh -"
    ]
  }
}

module "rancher_common" {
  source = "../rancher-common"

  node_public_ip = null
  rancher_nodes = [
  for index, x in linode_instance.rke[*] : {
    public_ip = linode_instance.rke[index].ip_address
    private_ip = ""
    roles = ["etcd", "controlplane", "worker"]
  }
  ]
  node_username          = var.node_username
  ssh_private_key_pem    = var.ssh_private_key_path
  rke_kubernetes_version = var.rke_kubernetes_version

  ingress_tls_source = "secret"
  cert_manager_version = ""
  server_certificate  = var.server_certificate
  server_certificate_key  = var.server_certificate_key
  rancher_version      = var.rancher_version

  rancher_server_dns = join(".", [var.rancher_server_name, var.linode_domain_for_rancher])

  admin_password = var.rancher_server_admin_password

  create_workload_cluster = var.create_workload_cluster
  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = var.workload_cluster_name
}
