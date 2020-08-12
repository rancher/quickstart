terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.2.4"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "1.12.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "1.4.0"

    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.10.0"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.0.1"

    }
  }
  required_version = ">= 0.13"
}
