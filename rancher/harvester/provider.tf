terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.6.1"
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

provider "harvester" {
  kubeconfig  = var.kubeconfig_path
  kubecontext = var.kubecontext
}
