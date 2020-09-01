# OpenStack Infrastructure Resources

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_file" "ssh_private_key_pem" {
  filename          = "${path.module}/id_rsa"
  sensitive_content = tls_private_key.global_key.private_key_pem
  file_permission   = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

# Upload Ubuntu image
resource "openstack_images_image_v2" "rancher-ubuntu-image" {
  name             = "${var.prefix}-rancher-ubuntu-image"
  image_source_url = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"
  min_ram_mb       = 4096
  min_disk_gb      = 25
  visibility       = "private"

  properties = {
    os_type    = "linux"
    os_distro  = "ubuntu"
    os_version = "18.04-LTS"
  }

  tags = ["rancher-quickstart"]
}

# Upload SSH keypair
resource "openstack_compute_keypair_v2" "rancher-keypair" {
  name       = "${var.prefix}-rancher-keypair"
  public_key = tls_private_key.global_key.public_key_openssh
}

# OpenStack virtual network for quickstart resources
resource "openstack_networking_network_v2" "rancher-quickstart" {
  name = "${var.prefix}-rancher-network"

  tags = ["rancher-quickstart"]
}

# OpenStack internal subnet for quickstart resources
resource "openstack_networking_subnet_v2" "rancher-quickstart-internal" {
  name       = "${var.prefix}-rancher-quickstart-internal"
  network_id = openstack_networking_network_v2.rancher-quickstart.id
  cidr       = var.network_cidr

  tags = ["rancher-quickstart"]
}

# Get floating IP network
data "openstack_networking_network_v2" "rancher-quickstart-external" {
  name = var.openstack_floating_ip_pool
}

# OpenStack router to connect the internal subnet to the floating IP network
resource "openstack_networking_router_v2" "rancher-quickstart-router" {
  name                = "${var.prefix}-rancher-router"
  external_network_id = data.openstack_networking_network_v2.rancher-quickstart-external.id

  tags = ["rancher-quickstart"]
}

# OpenStack router interface to the internal subnet
resource "openstack_networking_router_interface_v2" "rancher-quickstart-router-interface" {
  router_id = openstack_networking_router_v2.rancher-quickstart-router.id
  subnet_id = openstack_networking_subnet_v2.rancher-quickstart-internal.id
}

# Floating IP of Rancher server
resource "openstack_networking_floatingip_v2" "rancher-server-pip" {
  pool = var.openstack_floating_ip_pool

  tags = ["rancher-quickstart"]
}

# OpenStack network interface for quickstart resources
resource "openstack_networking_port_v2" "rancher-server-interface" {
  name       = "${var.prefix}-rancher-quickstart-interface"
  network_id = openstack_networking_network_v2.rancher-quickstart.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.rancher-quickstart-internal.id
  }

  tags = ["rancher-quickstart"]
}

# Associate Rancher server floating IP with the Rancher server port
resource "openstack_networking_floatingip_associate_v2" "rancher-server-pip-associate" {
  floating_ip = openstack_networking_floatingip_v2.rancher-server-pip.address
  port_id     = openstack_networking_port_v2.rancher-server-interface.id
}

# OpenStack security group
resource "openstack_networking_secgroup_v2" "rancher-quickstart-secgroup" {
  name = "${var.prefix}-rancher-secgroup"
}

# OpenStack security group rules
resource "openstack_networking_secgroup_rule_v2" "rancher-quickstart-secgroup-rule-ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.rancher-quickstart-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "rancher-quickstart-secgroup-rule-http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.rancher-quickstart-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "rancher-quickstart-secgroup-rule-https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.rancher-quickstart-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "rancher-quickstart-secgroup-rule-kubeapi" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 6443
  port_range_max    = 6443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.rancher-quickstart-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "rancher-quickstart-secgroup-rule-docker" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 2376
  port_range_max    = 2376
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_networking_secgroup_v2.rancher-quickstart-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "rancher-quickstart-secgroup-rule-self-v4" {
  direction         = "ingress"
  ethertype         = "IPv4"
  remote_group_id   = openstack_networking_secgroup_v2.rancher-quickstart-secgroup.id
  security_group_id = openstack_networking_secgroup_v2.rancher-quickstart-secgroup.id
}

resource "openstack_networking_secgroup_rule_v2" "rancher-quickstart-secgroup-rule-self-v6" {
  direction         = "ingress"
  ethertype         = "IPv6"
  remote_group_id   = openstack_networking_secgroup_v2.rancher-quickstart-secgroup.id
  security_group_id = openstack_networking_secgroup_v2.rancher-quickstart-secgroup.id
}

# Associate security group to Rancher server port
resource "openstack_networking_port_secgroup_associate_v2" "rancher-server-interface-secgroup" {
  port_id            = openstack_networking_port_v2.rancher-server-interface.id
  security_group_ids = [openstack_networking_secgroup_v2.rancher-quickstart-secgroup.id]
}

# Create CloudInit / User-Data for Rancher server
data "cloudinit_config" "rancher-server-cloudinit" {
  part {
    content_type = "text/x-shellscript"
    content = templatefile(
      join("/", [path.module, "../cloud-common/files/userdata_rancher_server.template"]),
      {
        docker_version = var.docker_version
        username       = local.node_username
      }
    )
  }
}

# OpenStack instance for creating a single node RKE cluster and installing the Rancher Server
resource "openstack_compute_instance_v2" "rancher_server" {
  name        = "${var.prefix}-rancher-server"
  flavor_name = var.instance_type
  key_pair    = openstack_compute_keypair_v2.rancher-keypair.name
  user_data   = data.cloudinit_config.rancher-server-cloudinit.rendered

  network {
    port = openstack_networking_port_v2.rancher-server-interface.id
  }

  block_device {
    uuid                  = openstack_images_image_v2.rancher-ubuntu-image.id
    source_type           = "image"
    volume_size           = 25
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.rancher-server-pip.address
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  tags = ["rancher-quickstart"]

}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip         = openstack_networking_floatingip_v2.rancher-server-pip.address
  node_internal_ip       = openstack_compute_instance_v2.rancher_server.access_ip_v4
  node_username          = local.node_username
  ssh_private_key_pem    = tls_private_key.global_key.private_key_pem
  rke_kubernetes_version = var.rke_kubernetes_version

  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version

  rancher_server_dns = join(".", ["rancher", openstack_networking_floatingip_v2.rancher-server-pip.address, "xip.io"])

  admin_password = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "${var.prefix}-quickstart-openstack-custom"
}

# Floating IP of quickstart node
resource "openstack_networking_floatingip_v2" "quickstart-node-pip" {
  pool = var.openstack_floating_ip_pool

  tags = ["rancher-quickstart"]
}

# OpenStack network interface for quickstart resources
resource "openstack_networking_port_v2" "quickstart-node-interface" {
  name       = "${var.prefix}-quickstart-node-interface"
  network_id = openstack_networking_network_v2.rancher-quickstart.id

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.rancher-quickstart-internal.id
  }

  tags = ["rancher-quickstart"]
}

# Associate Quickstart node floating IP with the Quickstart node port
resource "openstack_networking_floatingip_associate_v2" "quickstart-node-pip-associate" {
  floating_ip = openstack_networking_floatingip_v2.quickstart-node-pip.address
  port_id     = openstack_networking_port_v2.quickstart-node-interface.id
}

# Create CloudInit / User-Data for Quickstart node
data "cloudinit_config" "quickstart-node-cloudinit" {
  part {
    content_type = "text/x-shellscript"
    content = templatefile(
      join("/", [path.module, "files/userdata_quickstart_node.template"]),
      {
        docker_version   = var.docker_version
        username         = local.node_username
        register_command = module.rancher_common.custom_cluster_command
      }
    )
  }
}

# OpenStack instance for creating a single node RKE cluster and installing the Rancher Server
resource "openstack_compute_instance_v2" "quickstart-node" {
  name        = "${var.prefix}-rancher-quickstart-node"
  flavor_name = var.instance_type
  key_pair    = openstack_compute_keypair_v2.rancher-keypair.name
  user_data   = data.cloudinit_config.quickstart-node-cloudinit.rendered

  network {
    port = openstack_networking_port_v2.quickstart-node-interface.id
  }

  block_device {
    uuid                  = openstack_images_image_v2.rancher-ubuntu-image.id
    source_type           = "image"
    volume_size           = 25
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.quickstart-node-pip.address
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  tags = ["rancher-quickstart"]

}
