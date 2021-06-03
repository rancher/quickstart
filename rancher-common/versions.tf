terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "1.3.2"
    }
    k8s = {
      source  = "banzaicloud/k8s"
      version = "0.8.2"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.0.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "1.15.1"
    }
    rke = {
      source  = "rancher/rke"
      version = "1.2.2"
    }
  }
  required_version = ">= 0.13"
}
