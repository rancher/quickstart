terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.10.1"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.0"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "3.0.0"
    }
    ssh = {
      source  = "loafoe/ssh"
      version = "2.6.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "helm" {
  kubernetes {
    config_path = local_file.kube_config_server_yaml.filename
  }
}

# Rancher2 bootstrapping provider
provider "rancher2" {
  alias = "bootstrap"

  api_url  = "https://${var.rancher_server_dns}"
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  bootstrap = true
}

# Rancher2 administration provider
provider "rancher2" {
  alias = "admin"

  api_url  = "https://${var.rancher_server_dns}"
  insecure = true
  # ca_certs  = data.kubernetes_secret.rancher_cert.data["ca.crt"]
  token_key = rancher2_bootstrap.admin.token
  timeout   = "300s"
}
