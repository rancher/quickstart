# AWS infrastructure resources

# Temporary key pair used for SSH accesss
resource "aws_key_pair" "quickstart_key_pair" {
  key_name_prefix = "${var.prefix}-rancher-"
  public_key      = file("${var.ssh_key_file_name}.pub")
}

# Security group to allow all traffic
resource "aws_security_group" "rancher_sg_allowall" {
  name        = "${var.prefix}-rancher-allowall"
  description = "Rancher quickstart - allow all traffic"

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Creator = "rancher-quickstart"
  }
}

# AWS EC2 instance for creating a single node RKE cluster and installing the Rancher server
resource "aws_instance" "rancher_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name        = aws_key_pair.quickstart_key_pair.key_name
  security_groups = [aws_security_group.rancher_sg_allowall.name]

  user_data = templatefile("../cloud-common/files/userdata_rancher_server.template", {
    docker_version = var.docker_version
    username       = local.node_username
  })

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type = "ssh"

      # If the private key has a passphrase, is managed by an SSH agent, and 'agent' here is set to 'true', then
      # setting 'private_key' is counter-productive, as Terraform will follow the 'private_key' value before checking
      # with the SSH agent, load the encrypted key first, and subsequently fail with the following:
      #
      # Error: Failed to parse ssh private key: ssh: cannot decode encrypted private keys
      #
      # This is worked around with a single override input variable to toggle the behaviour appropriately.
      #
      # Ref:
      # - https://github.com/hashicorp/terraform/issues/13734#issuecomment-295061898
      # - https://www.hashicorp.com/blog/terraform-0-12-conditional-operator-improvements/

      agent       = var.override_ssh_agent
      host        = self.public_ip
      private_key = var.override_ssh_agent != null ? null : file(var.ssh_key_file_name)
      user        = local.node_username
    }
  }

  tags = {
    Name    = "${var.prefix}-rancher-server"
    Creator = "rancher-quickstart"
  }
}

# Rancher resources
module "rancher_common" {
  source = "../rancher-common"

  node_public_ip         = aws_instance.rancher_server.public_ip
  node_internal_ip       = aws_instance.rancher_server.private_ip
  node_username          = local.node_username
  ssh_key_file_name      = var.ssh_key_file_name
  rke_kubernetes_version = var.rke_kubernetes_version

  cert_manager_version = var.cert_manager_version
  rancher_version      = var.rancher_version

  rancher_server_dns = aws_instance.rancher_server.public_dns
  admin_password     = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-aws-custom"
}

# AWS EC2 instance for creating a single node workload cluster
resource "aws_instance" "quickstart_node" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  key_name        = aws_key_pair.quickstart_key_pair.key_name
  security_groups = [aws_security_group.rancher_sg_allowall.name]

  user_data = templatefile("../cloud-common/files/userdata_quickstart_node.template", {
    docker_version   = var.docker_version
    username         = local.node_username
    register_command = module.rancher_common.custom_cluster_command
  })

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait"
    ]

    connection {
      type = "ssh"

      agent       = var.override_ssh_agent
      host        = self.public_ip
      private_key = var.override_ssh_agent != null ? null : file(var.ssh_key_file_name)
      user        = local.node_username
    }
  }

  tags = {
    Name    = "${var.prefix}-quickstart-node"
    Creator = "rancher-quickstart"
  }
}
