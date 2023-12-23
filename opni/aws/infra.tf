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
  key_name_prefix = "${var.prefix}-opni-"
  public_key      = tls_private_key.global_key.public_key_openssh
}

resource "aws_vpc" "opni_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "${var.prefix}-opni-vpc"
  }
}

resource "aws_internet_gateway" "opni_gateway" {
  vpc_id = aws_vpc.opni_vpc.id

  tags = {
    Name = "${var.prefix}-opni-gateway"
  }
}

resource "aws_subnet" "opni_subnet" {
  vpc_id = aws_vpc.opni_vpc.id

  cidr_block        = "10.0.0.0/24"
  availability_zone = var.aws_zone

  tags = {
    Name = "${var.prefix}-opni-subnet"
  }
}

resource "aws_route_table" "opni_route_table" {
  vpc_id = aws_vpc.opni_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.opni_gateway.id
  }

  tags = {
    Name = "${var.prefix}-opni-route-table"
  }
}

resource "aws_route_table_association" "opni_route_table_association" {
  subnet_id      = aws_subnet.opni_subnet.id
  route_table_id = aws_route_table.opni_route_table.id
}


# Security group to allow all traffic
resource "aws_security_group" "opni_sg_allowall" {
  name        = "${var.prefix}-opni-allowall"
  description = "opni quickstart - allow all traffic"
  vpc_id      = aws_vpc.opni_vpc.id

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
    Creator = "opni-quickstart"
  }
}

# AWS EC2 instance for creating a single node RKE cluster and installing the RKE2 cluster, Rancher and opni
resource "aws_instance" "opni_server" {
  count = var.opni_cluster_node_count

  depends_on = [
    aws_route_table_association.opni_route_table_association
  ]
  ami           = data.aws_ami.sles.id
  instance_type = var.instance_type

  key_name                    = aws_key_pair.quickstart_key_pair.key_name
  vpc_security_group_ids      = [aws_security_group.opni_sg_allowall.id]
  subnet_id                   = aws_subnet.opni_subnet.id
  associate_public_ip_address = true

  root_block_device {
    volume_size = 200
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
    Name    = "${var.prefix}-opni-server"
    Creator = "opni-quickstart"
  }
}
