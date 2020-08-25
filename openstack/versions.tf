terraform {
  required_providers {
    openstack = {
      source  = "terraform-providers/openstack"
      version = "1.30.0"
    }
    local = {
      source = "hashicorp/local"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "2.2.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "1.0.0"
    }
  }
  required_version = ">= 0.13"
}
