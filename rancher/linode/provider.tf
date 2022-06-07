terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.27.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.2"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.1.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "linode" {
  token = var.linode_token
}
