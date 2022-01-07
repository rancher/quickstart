terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.22.2"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "1.0.1"
    }
  }
  required_version = ">= 1.0.0"
}
