# AWS infrastructure resources

resource "tls_private_key" "global_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "local_sensitive_file" "ssh_private_key_pem" {
  filename        = "${path.module}/id_rsa"
  content         = tls_private_key.global_key.private_key_pem
  file_permission = "0600"
}

resource "local_file" "ssh_public_key_openssh" {
  filename = "${path.module}/id_rsa.pub"
  content  = tls_private_key.global_key.public_key_openssh
}

# Temporary key pair used for SSH accesss
resource "outscale_keypair" "quickstart_key_pair" {
  keypair_name = "${var.prefix}-rancher-quickstart"
  public_key   = tls_private_key.global_key.public_key_openssh
}

# Security group to allow all traffic
resource "outscale_security_group" "rancher_sg_allowall" {
  security_group_name = "${var.prefix}-rancher-allowall"
  description         = "Rancher quickstart - allow all traffic"

  tags {
    key   = "creator"
    value = "rancher-quickstart"
  }
}

resource "outscale_security_group_rule" "security_group_rule01" {
  flow              = "Inbound"
  security_group_id = outscale_security_group.rancher_sg_allowall.id
  rules {
    from_port_range = "0"
    to_port_range   = "0"
    ip_protocol     = "-1"
    ip_ranges       = ["0.0.0.0/0"]
  }

}

resource "outscale_public_ip" "rancher_server" {}

resource "outscale_public_ip_link" "rancher_server" {
  vm_id     = outscale_vm.rancher_server.vm_id
  public_ip = outscale_public_ip.rancher_server.public_ip

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = outscale_public_ip.rancher_server.public_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}

# Instance for creating a single node RKE cluster and installing the Rancher server
resource "outscale_vm" "rancher_server" {
  image_id = var.omi
  vm_type  = var.instance_type

  keypair_name       = outscale_keypair.quickstart_key_pair.keypair_name
  security_group_ids = [outscale_security_group.rancher_sg_allowall.security_group_id]

  user_data = filebase64(join("/", [path.module, "files/userdata_rancher_server"]))

  block_device_mappings {
    device_name = "/dev/sda1"
    bsu {
      volume_size = 15
      volume_type = "io1"
      iops        = 1500
    }
  }

  tags {
    key   = "name"
    value = "${var.prefix}-rancher-server"
  }

  tags {
    key   = "creator"
    value = "rancher-quickstart"
  }

  tags {
    key   = "osc.fcu.eip.auto-attach"
    value = outscale_public_ip.rancher_server.public_ip
  }



}

// This looks strange but it apply dependency between rancher module and outscale cloud
data "outscale_public_ip" "rancher_server" {
  filter {
    name   = "public_ips"
    values = [outscale_public_ip.rancher_server.public_ip]
  }
  public_ip  = outscale_public_ip.rancher_server.public_ip
  depends_on = [outscale_public_ip_link.rancher_server, outscale_security_group_rule.security_group_rule01]
}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip             = data.outscale_public_ip.rancher_server.public_ip
  node_internal_ip           = outscale_vm.rancher_server.private_ip
  node_username              = local.node_username
  ssh_private_key_pem        = tls_private_key.global_key.private_key_pem
  rancher_kubernetes_version = var.rancher_kubernetes_version

  cert_manager_version    = var.cert_manager_version
  rancher_version         = var.rancher_version
  rancher_helm_repository = var.rancher_helm_repository

  rancher_server_dns = join(".", ["rancher", outscale_public_ip.rancher_server.public_ip, "sslip.io"])

  admin_password = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-outscale-custom"
}


resource "outscale_public_ip" "quickstart_node" {}

resource "outscale_public_ip_link" "quickstart_node" {
  vm_id     = outscale_vm.quickstart_node.vm_id
  public_ip = outscale_public_ip.quickstart_node.public_ip

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = outscale_public_ip.quickstart_node.public_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }
}

# Instance for creating a single node workload cluster
resource "outscale_vm" "quickstart_node" {
  image_id = var.omi
  vm_type  = var.instance_type

  keypair_name       = outscale_keypair.quickstart_key_pair.keypair_name
  security_group_ids = [outscale_security_group.rancher_sg_allowall.security_group_id]

  user_data = base64encode(templatefile(
    join("/", [path.module, "files/userdata_quickstart_node.template"]),
    {
      username         = local.node_username
      register_command = module.rancher_common.custom_cluster_command
    }
  ))

  block_device_mappings {
    device_name = "/dev/sda1"
    bsu {
      volume_size = 15
      volume_type = "io1"
      iops        = 1500
    }
  }

  tags {
    key   = "name"
    value = "${var.prefix}-quickstart-node"
  }

  tags {
    key   = "creator"
    value = "rancher-quickstart"
  }

  tags {
    key   = "osc.fcu.eip.auto-attach"
    value = outscale_public_ip.quickstart_node.public_ip
  }
}
