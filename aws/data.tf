# Data for AWS module

# AWS data
# ----------------------------------------------------------

# Use latest Ubuntu 18.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
# Use latest SLES 15 SP2 AMI
#data "susepubliccloud_image_ids" "sles" {
#  cloud      = "amazon"
#  region     = "us-east-1"
#  state      = "active"
#  name_regex = "suse-sles-15-sp2.*-hvm-ssd-x86_64"
#}
