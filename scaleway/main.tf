# Configure the Scaleway Provider
provider "scaleway" {
  organization = "${var.scw_org}"
  token        = "${var.scw_token}"
  region       = "${var.region}"
}

variable "scw_org" {}

variable "scw_token" {}

variable "prefix" {
  default = "yourname"
}

variable "rancher_version" {
  default = "latest"
}

variable "count_agent_all_nodes" {
  default = "3"
}

variable "count_agent_etcd_nodes" {
  default = "0"
}

variable "count_agent_controlplane_nodes" {
  default = "0"
}

variable "count_agent_worker_nodes" {
  default = "0"
}

variable "admin_password" {
  default = "admin"
}

variable "cluster_name" {
  default = "quickstart"
}

variable "region" {
  default = "par1"
}

variable "docker_version_server" {
  default = "17.03"
}

variable "docker_version_agent" {
  default = "17.03"
}

variable "type" {
  default = "START1-S"
}

data "scaleway_image" "xenial" {
  architecture = "x86_64"
  name         = "Ubuntu Xenial"
}

resource "scaleway_server" "rancherserver" {
  count               = "1"
  image               = "${data.scaleway_image.xenial.id}"
  type                = "${var.type}"
  name                = "${var.prefix}-rancherserver"
  security_group      = "${scaleway_security_group.allowall.id}"
  dynamic_ip_required = true
}

resource "scaleway_user_data" "rancherserver" {
  server = "${scaleway_server.rancherserver.id}"
  key    = "cloud-init"
  value  = "${data.template_file.userdata_server.rendered}"
}

resource "scaleway_server" "rancheragent_all" {
  count               = "${var.count_agent_all_nodes}"
  image               = "${data.scaleway_image.xenial.id}"
  type                = "${var.type}"
  name                = "${var.prefix}-rancheragent-${count.index}-all"
  security_group      = "${scaleway_security_group.allowall.id}"
  dynamic_ip_required = true
}

resource "scaleway_user_data" "rancheragent_all" {
  count  = "${var.count_agent_all_nodes}"
  server = "${scaleway_server.rancheragent_all.*.id[count.index]}"
  key    = "cloud-init"
  value  = "${data.template_file.userdata_agent.rendered}"
}

resource "scaleway_server" "rancheragent_etcd" {
  count               = "${var.count_agent_etcd_nodes}"
  image               = "${data.scaleway_image.xenial.id}"
  type                = "${var.type}"
  name                = "${var.prefix}-rancheragent-${count.index}-etcd"
  security_group      = "${scaleway_security_group.allowall.id}"
  dynamic_ip_required = true
}

resource "scaleway_user_data" "rancheragent_etcd" {
  count  = "${var.count_agent_etcd_nodes}"
  server = "${scaleway_server.rancheragent_etcd.*.id[count.index]}"
  key    = "cloud-init"
  value  = "${data.template_file.userdata_agent.rendered}"
}

resource "scaleway_server" "rancheragent_controlplane" {
  count               = "${var.count_agent_controlplane_nodes}"
  image               = "${data.scaleway_image.xenial.id}"
  type                = "${var.type}"
  name                = "${var.prefix}-rancheragent-${count.index}-controlplane"
  security_group      = "${scaleway_security_group.allowall.id}"
  dynamic_ip_required = true
}

resource "scaleway_user_data" "rancheragent_controlplane" {
  count  = "${var.count_agent_controlplane_nodes}"
  server = "${scaleway_server.rancheragent_controlplane.*.id[count.index]}"
  key    = "cloud-init"
  value  = "${data.template_file.userdata_agent.rendered}"
}

resource "scaleway_server" "rancheragent_worker" {
  count               = "${var.count_agent_worker_nodes}"
  image               = "${data.scaleway_image.xenial.id}"
  type                = "${var.type}"
  name                = "${var.prefix}-rancheragent-${count.index}-worker"
  security_group      = "${scaleway_security_group.allowall.id}"
  dynamic_ip_required = true
}

resource "scaleway_user_data" "rancheragent_worker" {
  count  = "${var.count_agent_worker_nodes}"
  server = "${scaleway_server.rancheragent_worker.*.id[count.index]}"
  key    = "cloud-init"
  value  = "${data.template_file.userdata_agent.rendered}"
}

data "template_file" "userdata_server" {
  template = "${file("files/userdata_server")}"

  vars {
    admin_password        = "${var.admin_password}"
    cluster_name          = "${var.cluster_name}"
    docker_version_server = "${var.docker_version_server}"
    rancher_version       = "${var.rancher_version}"
  }
}

data "template_file" "userdata_agent" {
  template = "${file("files/userdata_agent")}"

  vars {
    admin_password       = "${var.admin_password}"
    cluster_name         = "${var.cluster_name}"
    docker_version_agent = "${var.docker_version_agent}"
    rancher_version      = "${var.rancher_version}"
    server_address       = "${scaleway_server.rancherserver.public_ip}"
  }
}

resource "scaleway_security_group" "allowall" {
  name        = "allowall"
  description = "allow all traffic"
}

resource "scaleway_security_group_rule" "all_accept" {
  security_group = "${scaleway_security_group.allowall.id}"

  action    = "accept"
  direction = "inbound"
  ip_range  = "0.0.0.0/0"
  protocol  = "TCP"
}

output "rancher-url" {
  value = ["https://${scaleway_server.rancherserver.public_ip}"]
}
