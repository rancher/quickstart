terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.27.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }
  required_version = ">= 1.0.0"
}

provider "linode" {
  token = var.linode_token
}
