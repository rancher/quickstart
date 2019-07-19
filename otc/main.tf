data "opentelekomcloud_images_image_v2" "image" {
  name = "${var.image_name}"
  most_recent = true
}

resource "opentelekomcloud_vpc_v1" "vpc" {
  name = "${var.vpc_name}"
  cidr = "${var.vpc_cidr}"
}

resource "opentelekomcloud_vpc_subnet_v1" "subnet" {
  name       = "${var.subnet_name}"
  vpc_id     = "${opentelekomcloud_vpc_v1.vpc.id}"
  cidr       = "${var.subnet_cidr}"
  gateway_ip = "${var.subnet_gateway_ip}"
  dns_list   = ["100.125.4.25","8.8.8.8"]
}

resource "opentelekomcloud_networking_secgroup_v2" "quickstart-secgroup" {
  name = "${var.secgroup_name}"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "quickstart-secgroup_rule_1" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${opentelekomcloud_networking_secgroup_v2.quickstart-secgroup.id}"
}

resource "opentelekomcloud_networking_secgroup_rule_v2" "quickstart-secgroup_rule_2" {
  direction         = "egress"
  ethertype         = "IPv4"
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = "${opentelekomcloud_networking_secgroup_v2.quickstart-secgroup.id}"
}

resource "opentelekomcloud_compute_keypair_v2" "quickstart-key" {
  name       = "quickstart-key"
  public_key = "${var.public_key}"
}

resource "opentelekomcloud_compute_instance_v2" "ranchermaster_1" {
  name            = "ranchermaster_1"
  image_id        = "${data.opentelekomcloud_images_image_v2.image.id}"
  flavor_id       = "${var.flavor_id}"
  key_pair        = "${opentelekomcloud_compute_keypair_v2.quickstart-key.name}"
  security_groups = ["${opentelekomcloud_networking_secgroup_v2.quickstart-secgroup.id}"]
  user_data       = "${data.template_file.userdata_server.rendered}"
  network {
    uuid = "${opentelekomcloud_vpc_subnet_v1.subnet.id}"
  }
}

resource "opentelekomcloud_networking_floatingip_v2" "eip_1" {
  pool = "admin_external_net"
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "eip_1" {
  floating_ip = "${opentelekomcloud_networking_floatingip_v2.eip_1.address}"
  instance_id = "${opentelekomcloud_compute_instance_v2.ranchermaster_1.id}"
}

resource "opentelekomcloud_compute_instance_v2" "rancheragent_1-all" {
  name            = "rancheragent_1-all"
  image_id        = "${data.opentelekomcloud_images_image_v2.image.id}"
  flavor_id       = "${var.flavor_id}"
  key_pair        = "${opentelekomcloud_compute_keypair_v2.quickstart-key.name}"
  security_groups = ["${opentelekomcloud_networking_secgroup_v2.quickstart-secgroup.id}"]
  user_data       = "${data.template_file.userdata_agent.rendered}"
  network {
    uuid = "${opentelekomcloud_vpc_subnet_v1.subnet.id}"
  }
}

resource "opentelekomcloud_networking_floatingip_v2" "eip_2" {
  pool = "admin_external_net"
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "eip_2" {
  floating_ip = "${opentelekomcloud_networking_floatingip_v2.eip_2.address}"
  instance_id = "${opentelekomcloud_compute_instance_v2.rancheragent_1-all.id}"
}

resource "opentelekomcloud_compute_instance_v2" "rancheragent_2-all" {
  name            = "rancheragent_2-all"
  image_id        = "${data.opentelekomcloud_images_image_v2.image.id}"
  flavor_id       = "${var.flavor_id}"
  key_pair        = "${opentelekomcloud_compute_keypair_v2.quickstart-key.name}"
  security_groups = ["${opentelekomcloud_networking_secgroup_v2.quickstart-secgroup.id}"]
  user_data       = "${data.template_file.userdata_agent.rendered}"
  network {
    uuid = "${opentelekomcloud_vpc_subnet_v1.subnet.id}"
  }
}

resource "opentelekomcloud_networking_floatingip_v2" "eip_3" {
  pool = "admin_external_net"
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "eip_3" {
  floating_ip = "${opentelekomcloud_networking_floatingip_v2.eip_3.address}"
  instance_id = "${opentelekomcloud_compute_instance_v2.rancheragent_2-all.id}"
}

data "template_file" "userdata_server" {
  template = "${file("files/userdata_server")}"
  vars = {
    admin_password        = "${var.admin_password}"
    cluster_name          = "${var.cluster_name}"
    docker_version_server = "${var.docker_version_server}"
    rancher_version       = "${var.rancher_version}"
  }
}

data "template_file" "userdata_agent" {
  template = "${file("files/userdata_agent")}"
  vars = {
    admin_password       = "${var.admin_password}"
    cluster_name         = "${var.cluster_name}"
    docker_version_agent = "${var.docker_version_agent}"
    rancher_version      = "${var.rancher_version}"
    server_address       = "${opentelekomcloud_compute_instance_v2.ranchermaster_1.access_ip_v4}"
  }
}
