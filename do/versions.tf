terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "2.0.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
  }
  required_version = ">= 0.13"
}
