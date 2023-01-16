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
resource "aws_key_pair" "quickstart_key_pair" {
  key_name_prefix = "${var.prefix}-rancher-"
  public_key      = tls_private_key.global_key.public_key_openssh
}

resource "aws_vpc" "rancher_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-rancher-vpc"
  }
}

resource "aws_internet_gateway" "rancher_gateway" {
  vpc_id = aws_vpc.rancher_vpc.id

  tags = {
    Name = "${var.prefix}-rancher-gateway"
  }
}

resource "aws_subnet" "rancher_subnet" {
  vpc_id = aws_vpc.rancher_vpc.id

  cidr_block        = "10.0.0.0/24"
  availability_zone = var.aws_zone

  tags = {
    Name = "${var.prefix}-rancher-subnet"
  }
}

resource "aws_route_table" "rancher_route_table" {
  vpc_id = aws_vpc.rancher_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.rancher_gateway.id
  }

  tags = {
    Name = "${var.prefix}-rancher-route-table"
  }
}

resource "aws_route_table_association" "rancher_route_table_association" {
  subnet_id      = aws_subnet.rancher_subnet.id
  route_table_id = aws_route_table.rancher_route_table.id
}

# Security group to allow all traffic
resource "aws_security_group" "rancher_sg_allowall" {
  name        = "${var.prefix}-rancher-allowall"
  description = "Rancher quickstart - allow all traffic"
  vpc_id      = aws_vpc.rancher_vpc.id

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
  depends_on = [
    aws_route_table_association.rancher_route_table_association
  ]
  ami           = data.aws_ami.sles.id
  instance_type = var.instance_type

  key_name                    = aws_key_pair.quickstart_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.rancher_sg_allowall.id]
  subnet_id                   = aws_subnet.rancher_subnet.id
  associate_public_ip_address = true

  root_block_device {
    volume_size = 40
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
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

  node_public_ip             = aws_instance.rancher_server.public_ip
  node_internal_ip           = aws_instance.rancher_server.private_ip
  node_username              = local.node_username
  ssh_private_key_pem        = tls_private_key.global_key.private_key_pem
  rancher_kubernetes_version = var.rancher_kubernetes_version

  cert_manager_version    = var.cert_manager_version
  rancher_version         = var.rancher_version
  rancher_helm_repository = var.rancher_helm_repository

  rancher_server_dns = join(".", ["rancher", aws_instance.rancher_server.public_ip, "sslip.io"])

  admin_password = var.rancher_server_admin_password

  workload_kubernetes_version = var.workload_kubernetes_version
  workload_cluster_name       = "quickstart-aws-custom"
}

# AWS EC2 instance for creating a single node workload cluster
resource "aws_instance" "quickstart_node" {
  depends_on = [
    aws_route_table_association.rancher_route_table_association
  ]
  ami           = data.aws_ami.sles.id
  instance_type = var.instance_type

  key_name                    = aws_key_pair.quickstart_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.rancher_sg_allowall.id]
  subnet_id                   = aws_subnet.rancher_subnet.id
  associate_public_ip_address = true

  root_block_device {
    volume_size = 40
  }

  user_data = templatefile(
    "${path.module}/files/userdata_quickstart_node.template",
    {
      register_command = module.rancher_common.custom_cluster_command
    }
  )

  provisioner "remote-exec" {
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'",
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = local.node_username
      private_key = tls_private_key.global_key.private_key_pem
    }
  }

  tags = {
    Name    = "${var.prefix}-quickstart-node"
    Creator = "rancher-quickstart"
  }
}
