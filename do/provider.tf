terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.19.0"
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

provider "digitalocean" {
  token = var.do_token
}
