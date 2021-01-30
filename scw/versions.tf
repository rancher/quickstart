terraform {
  required_providers {
    terraform = {
      source  = "scaleway/scaleway"
      version = "1.16.0"
    }
    local = {
      source = "hashicorp/local"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "2.2.0"
    }
    scaleway = {
      source = "terraform-providers/scaleway"
    }
  }
  required_version = ">= 0.13"
}
