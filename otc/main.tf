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

resource "opentelekomcloud_compute_instance_v2" "ranchermaster" {
  name              = "ranchermaster"
  availability_zone = "${var.availability_zone1}"
  flavor_id         = "${var.flavor_id}"
  key_pair          = "${opentelekomcloud_compute_keypair_v2.quickstart-key.name}"
  security_groups   = ["${opentelekomcloud_networking_secgroup_v2.quickstart-secgroup.id}"]
  user_data         = "${data.template_file.userdata_server.rendered}"
  network {
    uuid = "${opentelekomcloud_vpc_subnet_v1.subnet.id}"
  }
  block_device {
    boot_index            = 0
    source_type           = "image"
    destination_type      = "volume"
    uuid                  = "${data.opentelekomcloud_images_image_v2.image.id}"
    delete_on_termination = true
    volume_size           = 30
  }
}

resource "opentelekomcloud_networking_floatingip_v2" "eip_ranchermaster" {
  pool = "admin_external_net"
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "eip_ranchermaster" {
  floating_ip = "${opentelekomcloud_networking_floatingip_v2.eip_ranchermaster.address}"
  instance_id = "${opentelekomcloud_compute_instance_v2.ranchermaster.id}"
}

resource "opentelekomcloud_compute_instance_v2" "rancheragent_1-all" {
  name              = "rancheragent_1-all"
  availability_zone = "${var.availability_zone1}"
  flavor_id         = "${var.flavor_id}"
  key_pair          = "${opentelekomcloud_compute_keypair_v2.quickstart-key.name}"
  security_groups   = ["${opentelekomcloud_networking_secgroup_v2.quickstart-secgroup.id}"]
  user_data         = "${data.template_file.userdata_agent.rendered}"
  network {
    uuid = "${opentelekomcloud_vpc_subnet_v1.subnet.id}"
  }
  block_device {
    boot_index            = 0
    source_type           = "image"
    destination_type      = "volume"
    uuid                  = "${data.opentelekomcloud_images_image_v2.image.id}"
    delete_on_termination = true
    volume_size           = 30
  }
}

resource "opentelekomcloud_networking_floatingip_v2" "eip_rancheragent_1" {
  pool = "admin_external_net"
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "eip_rancheragent_1" {
  floating_ip = "${opentelekomcloud_networking_floatingip_v2.eip_rancheragent_1.address}"
  instance_id = "${opentelekomcloud_compute_instance_v2.rancheragent_1-all.id}"
}

resource "opentelekomcloud_compute_instance_v2" "rancheragent_2-all" {
  name              = "rancheragent_2-all"
  availability_zone = "${var.availability_zone2}"
  flavor_id         = "${var.flavor_id}"
  key_pair          = "${opentelekomcloud_compute_keypair_v2.quickstart-key.name}"
  security_groups   = ["${opentelekomcloud_networking_secgroup_v2.quickstart-secgroup.id}"]
  user_data         = "${data.template_file.userdata_agent.rendered}"
  network {
    uuid = "${opentelekomcloud_vpc_subnet_v1.subnet.id}"
  }
  block_device {
    boot_index            = 0
    source_type           = "image"
    destination_type      = "volume"
    uuid                  = "${data.opentelekomcloud_images_image_v2.image.id}"
    delete_on_termination = true
    volume_size           = 30
  }
}

resource "opentelekomcloud_networking_floatingip_v2" "eip_rancheragent_2" {
  pool = "admin_external_net"
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "eip_rancheragent_2" {
  floating_ip = "${opentelekomcloud_networking_floatingip_v2.eip_rancheragent_2.address}"
  instance_id = "${opentelekomcloud_compute_instance_v2.rancheragent_2-all.id}"
}

resource "opentelekomcloud_compute_instance_v2" "rancheragent_3-all" {
  name              = "rancheragent_3-all"
  availability_zone = "${var.availability_zone3}"
  flavor_id         = "${var.flavor_id}"
  key_pair          = "${opentelekomcloud_compute_keypair_v2.quickstart-key.name}"
  security_groups   = ["${opentelekomcloud_networking_secgroup_v2.quickstart-secgroup.id}"]
  user_data         = "${data.template_file.userdata_agent.rendered}"
  network {
    uuid = "${opentelekomcloud_vpc_subnet_v1.subnet.id}"
  }
  block_device {
    boot_index            = 0
    source_type           = "image"
    destination_type      = "volume"
    uuid                  = "${data.opentelekomcloud_images_image_v2.image.id}"
    delete_on_termination = true
    volume_size           = 30
  }
}

resource "opentelekomcloud_networking_floatingip_v2" "eip_rancheragent_3" {
  pool = "admin_external_net"
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "eip_rancheragent_3" {
  floating_ip = "${opentelekomcloud_networking_floatingip_v2.eip_rancheragent_3.address}"
  instance_id = "${opentelekomcloud_compute_instance_v2.rancheragent_3-all.id}"
}

resource "opentelekomcloud_compute_instance_v2" "rancherworker_1-worker" {
  name              = "rancherworker_1-worker"
  availability_zone = "${var.availability_zone3}"
  flavor_id         = "${var.flavor_id}"
  key_pair          = "${opentelekomcloud_compute_keypair_v2.quickstart-key.name}"
  security_groups   = ["${opentelekomcloud_networking_secgroup_v2.quickstart-secgroup.id}"]
  user_data         = "${data.template_file.userdata_agent.rendered}"
  network {
    uuid = "${opentelekomcloud_vpc_subnet_v1.subnet.id}"
  }
  block_device {
    boot_index            = 0
    source_type           = "image"
    destination_type      = "volume"
    uuid                  = "${data.opentelekomcloud_images_image_v2.image.id}"
    delete_on_termination = true
    volume_size           = 30
  }
}

resource "opentelekomcloud_networking_floatingip_v2" "eip_rancherworker_1" {
  pool = "admin_external_net"
}

resource "opentelekomcloud_compute_floatingip_associate_v2" "eip_rancherworker_1" {
  floating_ip = "${opentelekomcloud_networking_floatingip_v2.eip_rancherworker_1.address}"
  instance_id = "${opentelekomcloud_compute_instance_v2.rancherworker_1-worker.id}"
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
    server_address       = "${opentelekomcloud_compute_instance_v2.ranchermaster.access_ip_v4}"
  }
}
