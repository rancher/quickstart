terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.6.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.2.3"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "harvester" {
}
